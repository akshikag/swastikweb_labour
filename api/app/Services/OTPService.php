<?php

namespace App\Services;

use Carbon\Carbon;

class OTPService
{
    public function hasManualOTP(): bool
    {
        return preg_match('/^\d{6}$/', (string) config('services.sms.manual_otp')) === 1;
    }

    public function verifyManualOTP(string $otp): bool
    {
        return $this->hasManualOTP()
            && hash_equals((string) config('services.sms.manual_otp'), $otp);
    }

    /**
     * Generate a random 6-digit OTP
     */
    public function generateOTP(): string
    {
        if ($this->hasManualOTP()) {
            return (string) config('services.sms.manual_otp');
        }

        return str_pad((string) rand(0, 999999), 6, '0', STR_PAD_LEFT);
    }

    /**
     * Send OTP via SMS
     * Supports multiple providers: twilio, aws-sns, mock
     */
    public function sendOTP(string $phone, string $otp): bool
    {
        if ($this->hasManualOTP()) {
            return $this->sendViaMock($phone, $otp);
        }

        $provider = config('services.sms.provider', 'mock');

        return match($provider) {
            'twilio' => $this->sendViaTwilio($phone, $otp),
            'aws-sns' => $this->sendViaAwsSNS($phone, $otp),
            default => $this->sendViaMock($phone, $otp),
        };
    }

    /**
     * Send OTP via Twilio
     */
    private function sendViaTwilio(string $phone, string $otp): bool
    {
        try {
            $accountSid = config('services.twilio.account_sid');
            $authToken = config('services.twilio.auth_token');
            $fromNumber = config('services.twilio.phone_number');

            if (!$accountSid || !$authToken || !$fromNumber) {
                \Log::warning('Twilio credentials not configured');
                return false;
            }

            $client = new \Twilio\Rest\Client($accountSid, $authToken);

            $message = "Your OTP is: {$otp}. Valid for 10 minutes. Do not share with anyone.";

            $client->messages->create(
                "+91{$phone}",
                array(
                    "from" => $fromNumber,
                    "body" => $message
                )
            );

            \Log::info("OTP sent successfully to {$phone}");
            return true;
        } catch (\Exception $e) {
            \Log::error("Twilio SMS sending failed: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Send OTP via AWS SNS
     */
    private function sendViaAwsSNS(string $phone, string $otp): bool
    {
        try {
            $client = new \Aws\Sns\SnsClient([
                'version' => 'latest',
                'region'  => config('services.aws.region', 'us-east-1'),
            ]);

            $message = "Your OTP is: {$otp}. Valid for 10 minutes. Do not share with anyone.";

            $result = $client->publish([
                'Message' => $message,
                'PhoneNumber' => "+91{$phone}",
            ]);

            \Log::info("OTP sent successfully via AWS SNS to {$phone}");
            return true;
        } catch (\Exception $e) {
            \Log::error("AWS SNS SMS sending failed: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Mock SMS sending (for development/testing)
     */
    private function sendViaMock(string $phone, string $otp): bool
    {
        \Log::info("MOCK: OTP {$otp} would be sent to {$phone}");
        return true;
    }

    /**
     * Store OTP for a user model
     */
    public function storeOTP($user, string $otp, int $expiryMinutes = 10): void
    {
        $user->update([
            'otp' => $otp,
            'otp_expires_at' => Carbon::now()->addMinutes($expiryMinutes),
        ]);
    }

    /**
     * Verify OTP for a user
     */
    public function verifyOTP($user, string $otp): bool
    {
        if (!$user->otp || !$user->otp_expires_at) {
            return false;
        }

        if ($user->otp !== $otp) {
            return false;
        }

        if (Carbon::now()->isAfter($user->otp_expires_at)) {
            return false;
        }

        return true;
    }

    /**
     * Clear OTP after verification
     */
    public function clearOTP($user): void
    {
        $user->update([
            'otp' => null,
            'otp_expires_at' => null,
        ]);
    }
}
