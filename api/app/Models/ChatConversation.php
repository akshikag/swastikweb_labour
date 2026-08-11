<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChatConversation extends Model
{
    protected $fillable = [
        'sender_type',
        'sender_id',
        'receiver_type',
        'receiver_id',
        'last_message',
        'last_message_at',
    ];

    public function messages()
    {
        return $this->hasMany(ChatMessage::class, 'conversation_id');
    }
}
