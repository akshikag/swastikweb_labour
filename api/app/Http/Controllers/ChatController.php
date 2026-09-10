<?php

namespace App\Http\Controllers;

use App\Models\ChatConversation;
use App\Models\ChatMessage;
use App\Models\Employer;
use App\Models\Worker;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ChatController extends Controller
{
    public function conversations()
    {
        $currentUser = Auth::user();

        $conversations = ChatConversation::where(function ($query) use ($currentUser) {
            $query->where('sender_type', $this->resolveUserType($currentUser))
                ->where('sender_id', $currentUser->getKey());
        })->orWhere(function ($query) use ($currentUser) {
            $query->where('receiver_type', $this->resolveUserType($currentUser))
                ->where('receiver_id', $currentUser->getKey());
        })->orderByDesc('last_message_at')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $conversations->map(fn (ChatConversation $conversation) => $this->formatConversationSummary($conversation, $currentUser)),
        ]);
    }

    public function show(Request $request, $peerId)
    {
        $currentUser = Auth::user();
        $peer = $this->resolvePeer($currentUser, $peerId);

        if (! $peer) {
            return response()->json([
                'success' => false,
                'message' => 'User not found.',
            ], 404);
        }

        $conversation = $this->findOrCreateConversation($currentUser, $peer);

        return response()->json([
            'success' => true,
            'data' => $this->formatConversation($conversation, $currentUser),
        ]);
    }

    public function send(Request $request)
    {
        $request->validate([
            'peer_id' => 'required|integer',
            'message' => 'required|string|min:1',
        ]);

        $currentUser = Auth::user();
        $peer = $this->resolvePeer($currentUser, $request->input('peer_id'));

        if (! $peer) {
            return response()->json([
                'success' => false,
                'message' => 'User not found.',
            ], 404);
        }

        $conversation = $this->findOrCreateConversation($currentUser, $peer);

        $message = $conversation->messages()->create([
            'sender_type' => $this->resolveUserType($currentUser),
            'sender_id' => $currentUser->getKey(),
            'message' => trim($request->input('message')),
        ]);

        $conversation->update([
            'last_message' => $message->message,
            'last_message_at' => $message->created_at,
        ]);

        return response()->json([
            'success' => true,
            'data' => [
                'conversation_id' => $conversation->id,
                'message' => $message->message,
                'sender_id' => $message->sender_id,
                'timestamp' => $message->created_at->toISOString(),
            ],
        ]);
    }

    protected function findOrCreateConversation($currentUser, $peerUser)
    {
        $currentType = $this->resolveUserType($currentUser);
        $peerType = $this->resolveUserType($peerUser);

        $conversation = ChatConversation::where(function ($query) use ($currentUser, $currentType, $peerUser, $peerType) {
            $query->where('sender_type', $currentType)
                ->where('sender_id', $currentUser->getKey())
                ->where('receiver_type', $peerType)
                ->where('receiver_id', $peerUser->getKey());
        })->orWhere(function ($query) use ($currentUser, $currentType, $peerUser, $peerType) {
            $query->where('sender_type', $peerType)
                ->where('sender_id', $peerUser->getKey())
                ->where('receiver_type', $currentType)
                ->where('receiver_id', $currentUser->getKey());
        })->first();

        if ($conversation) {
            return $conversation;
        }

        return ChatConversation::create([
            'sender_type' => $currentType,
            'sender_id' => $currentUser->getKey(),
            'receiver_type' => $peerType,
            'receiver_id' => $peerUser->getKey(),
        ]);
    }

    protected function formatConversation(ChatConversation $conversation, $currentUser)
    {
        $partner = $this->getPartner($conversation, $currentUser);

        return [
            'id' => $conversation->id,
            'partner_id' => $partner?->id,
            'partner_type' => $this->resolveUserType($partner),
            'name' => $this->resolveDisplayName($partner),
            'last_message' => $conversation->last_message,
            'last_message_at' => $conversation->last_message_at,
            'messages' => $conversation->messages()->orderBy('created_at')->get()->map(fn (ChatMessage $message) => [
                'id' => $message->id,
                'text' => $message->message,
                'senderId' => $message->sender_id,
                'senderType' => $message->sender_type,
                'timestamp' => $message->created_at->toISOString(),
            ])->values(),
        ];
    }

    protected function formatConversationSummary(ChatConversation $conversation, $currentUser)
    {
        $partner = $this->getPartner($conversation, $currentUser);

        return [
            'id' => $conversation->id,
            'partner_id' => $partner?->id,
            'partner_type' => $this->resolveUserType($partner),
            'name' => $this->resolveDisplayName($partner),
            'lastMessage' => $conversation->last_message ?? 'Start a conversation',
            'messages' => [],
            'unread' => 0,
        ];
    }

    /**
     * A chat always joins a worker with an employer. IDs are generated
     * independently for those tables, so looking in both tables by ID can
     * accidentally resolve the current worker instead of the employer.
     */
    protected function resolvePeer($currentUser, $peerId)
    {
        return $this->resolveUserType($currentUser) === 'worker'
            ? Employer::find($peerId)
            : Worker::find($peerId);
    }

    protected function resolveDisplayName($user)
    {
        if (! $user) {
            return 'Unknown';
        }

        $profile = $user->profile;
        if ($profile && isset($profile->name) && $profile->name) {
            return $profile->name;
        }

        if (! empty($user->name)) {
            return $user->name;
        }

        if (! empty($user->email)) {
            return $user->email;
        }

        return 'Unknown';
    }

    protected function getPartner(ChatConversation $conversation, $currentUser)
    {
        $currentType = $this->resolveUserType($currentUser);
        $currentId = $currentUser->getKey();

        if ($conversation->sender_type === $currentType && $conversation->sender_id === $currentId) {
            return $this->findParticipant($conversation->receiver_type, $conversation->receiver_id);
        }

        return $this->findParticipant($conversation->sender_type, $conversation->sender_id);
    }

    protected function findParticipant($type, $id)
    {
        if ($type === 'worker') {
            return Worker::find($id);
        }

        return Employer::find($id);
    }

    protected function resolveUserType($user)
    {
        if ($user instanceof Worker) {
            return 'worker';
        }

        return 'employer';
    }
}
