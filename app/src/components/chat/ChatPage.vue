<template>
    <BackButtonAppBar />

    <v-container fluid class="pa-0" style="height: calc(100vh - 64px - 56px);">
        <v-row style="height: 100%; overflow: hidden;">
            <v-col cols="4" class="chat-sidebar pa-2" style="border-right:1px solid #ddd; overflow-y: auto;">
                <chat-sidebar :chats="chats" :selectedChatId="selectedConversationId" @selectChat="openChat" />
            </v-col>

            <v-col cols="8" class="chat-window pa-2" style="display: flex; flex-direction: column; height: 100%;">
                <chat-window v-if="activeChat" :chat="activeChat" :currentUser="currentUser" @sendMessage="sendMessage"
                    :broadcastMode="broadcastMode" @sendBroadcast="sendBroadcast" />
                <div v-else class="text-center grey--text mt-5">
                    Select User to start messaging
                </div>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import BackButtonAppBar from '@/components/header/BackButtonAppBar.vue';
import ChatSidebar from '@/components/chat/ChatSidebar.vue';
import ChatWindow from '@/components/chat/ChatWindow.vue';
import { useRoute, useRouter } from 'vue-router';
import api from '@/services/api';
import apiRoutes from '@/services/apiRoutes';

const route = useRoute();
const router = useRouter();

function normalizeChatId(id) {
    if (!id) return null;
    const numericId = Number(id);
    return Number.isNaN(numericId) ? null : numericId;
}

function getStoredUser() {
    try {
        const storedUser = JSON.parse(localStorage.getItem('labour_currentUser') || '{}');
        const userType = localStorage.getItem('labouchowk_userType') || 'worker';
        const profileName = storedUser?.worker?.profile?.name
            || storedUser?.employer?.profile?.name
            || storedUser?.name
            || storedUser?.user?.name
            || 'User';
        const userId = storedUser?.worker?.id || storedUser?.employer?.id || storedUser?.id || 1;

        return { id: userId, type: userType, name: profileName };
    } catch (error) {
        console.warn('Unable to read chat user from storage', error);
        return { id: 1, type: 'worker', name: 'User' };
    }
}

function normalizeConversation(payload) {
    return {
        id: payload.id,
        partner_id: payload.partner_id,
        name: payload.name || 'Unknown',
        lastMessage: payload.last_message || 'Start a conversation',
        unread: 0,
        messages: (payload.messages || []).map((message) => ({
            id: message.id,
            text: message.text,
            senderId: message.senderId,
            timestamp: message.timestamp,
        })),
    };
}

const currentUser = ref(getStoredUser());
const chats = ref([]);
const selectedConversationId = ref(null);
const selectedPeerId = ref(normalizeChatId(route.params.id));
const activeChat = computed(() => chats.value.find((chat) => chat.id === selectedConversationId.value));
const broadcastMode = ref(false);

async function loadConversations() {
    try {
        const response = await api.get(apiRoutes.chatConversations);
        const payload = response?.data?.data || [];
        chats.value = payload.map(normalizeConversation);

        if (selectedPeerId.value) {
            const existingConversation = chats.value.find((chat) => chat.partner_id === selectedPeerId.value);
            if (existingConversation) {
                selectedConversationId.value = existingConversation.id;
            } else {
                await loadConversation(selectedPeerId.value);
            }
        } else if (!selectedConversationId.value && chats.value.length) {
            selectedConversationId.value = chats.value[0].id;
        }
    } catch (error) {
        console.error('Unable to load conversations', error);
    }
}

async function loadConversation(peerId) {
    const normalizedPeerId = normalizeChatId(peerId);
    if (!normalizedPeerId) return;

    try {
        const response = await api.get(`${apiRoutes.chatConversations}/${normalizedPeerId}`);
        const conversation = normalizeConversation(response?.data?.data || {});
        const existingIndex = chats.value.findIndex((chat) => chat.id === conversation.id);

        if (existingIndex >= 0) {
            chats.value[existingIndex] = conversation;
        } else {
            chats.value.unshift(conversation);
        }

        selectedConversationId.value = conversation.id;
        selectedPeerId.value = normalizedPeerId;
        broadcastMode.value = false;

        if (String(route.params.id || '') !== String(normalizedPeerId)) {
            router.replace({ name: 'worker-chat', params: { id: normalizedPeerId } });
        }
    } catch (error) {
        console.error('Unable to load conversation', error);
    }
}

watch(
    () => route.params.id,
    async (newId) => {
        const normalizedPeerId = normalizeChatId(newId);
        selectedPeerId.value = normalizedPeerId;

        if (!normalizedPeerId) {
            if (!selectedConversationId.value && chats.value.length) {
                selectedConversationId.value = chats.value[0].id;
            }
            return;
        }

        const existingConversation = chats.value.find((chat) => chat.partner_id === normalizedPeerId);
        if (existingConversation) {
            selectedConversationId.value = existingConversation.id;
        } else {
            await loadConversation(normalizedPeerId);
        }
    },
    { immediate: true }
);

onMounted(() => {
    loadConversations();
});

function openChat(chatId) {
    const normalizedChatId = normalizeChatId(chatId);
    const selectedChat = chats.value.find((chat) => chat.partner_id === normalizedChatId || chat.id === normalizedChatId);

    if (selectedChat) {
        selectedConversationId.value = selectedChat.id;
        selectedPeerId.value = selectedChat.partner_id || normalizedChatId;
        broadcastMode.value = false;

        if (String(route.params.id || '') !== String(selectedPeerId.value)) {
            router.push({ name: 'worker-chat', params: { id: selectedPeerId.value } });
        }
    }
}

async function sendMessage(message) {
    if (!activeChat.value) return;

    try {
        const response = await api.post(apiRoutes.chatSendMessage, {
            peer_id: activeChat.value.partner_id || selectedPeerId.value,
            message,
        });

        const messagePayload = response?.data?.data;
        activeChat.value.messages.push({
            id: Date.now(),
            text: messagePayload?.message || message,
            senderId: currentUser.value.id,
            timestamp: messagePayload?.timestamp || new Date().toISOString(),
        });
        activeChat.value.lastMessage = messagePayload?.message || message;
    } catch (error) {
        console.error('Unable to send message', error);
    }
}

function sendBroadcast(message) {
    sendMessage(message);
}
</script>

<style scoped>
.chat-sidebar {
    background-color: #f9f9f9;
}

.chat-window {
    display: flex;
    flex-direction: column;
}

.chat-window-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow-y: auto;
    padding-bottom: 8px;
}

.v-main {
    padding-bottom: 0px !important;
}
</style>
