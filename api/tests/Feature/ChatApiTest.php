<?php

namespace Tests\Feature;

use App\Models\Employer;
use App\Models\Worker;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class ChatApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_worker_can_create_a_conversation_and_send_a_message(): void
    {
        $worker = Worker::create([
            'email' => 'worker@example.com',
            'phone' => '9999999999',
            'password' => Hash::make('password123'),
        ]);

        $employer = Employer::create([
            'email' => 'employer@example.com',
            'phone' => '8888888888',
            'password' => Hash::make('password123'),
        ]);

        Auth::guard('worker')->setUser($worker);
        Auth::guard('employer')->setUser($employer);

        $response = $this->getJson('/api/chat/conversations/' . $employer->id);

        $response->assertStatus(200)
            ->assertJsonPath('data.partner_id', $employer->id)
            ->assertJsonPath('data.messages', []);

        $sendResponse = $this->postJson('/api/chat/messages', [
            'peer_id' => $employer->id,
            'message' => 'Hello from worker',
        ]);

        $sendResponse->assertStatus(200)
            ->assertJsonPath('data.message', 'Hello from worker');

        $this->assertDatabaseHas('chat_conversations', [
            'sender_type' => 'worker',
            'sender_id' => $worker->id,
            'receiver_type' => 'employer',
            'receiver_id' => $employer->id,
        ]);

        $this->assertDatabaseHas('chat_messages', [
            'message' => 'Hello from worker',
        ]);
    }
}
