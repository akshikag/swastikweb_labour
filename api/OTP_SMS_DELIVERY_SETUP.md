# OTP SMS Delivery Implementation

## Overview
The OTP (One-Time Password) system now supports actual SMS delivery through multiple providers. The backend generates OTPs, stores them with expiration times, and sends them via SMS.

## Features
- **Backend OTP Generation**: Secure random 6-digit OTP generation
- **Database Storage**: OTPs stored with 10-minute expiration
- **SMS Providers**: Support for Twilio, AWS SNS, and mock (for development)
- **Frontend Integration**: Vue components integrated with backend API endpoints
- **Resend Limits**: Max 3 resend attempts per registration/forgot-password flow

## Setup

### 1. Database Migration
Run the migration to add OTP fields to workers and employers tables:
```bash
php artisan migrate
```

This creates:
- `otp` (string) - Stores the 6-digit OTP
- `otp_expires_at` (timestamp) - OTP expiration time

### 2. Environment Configuration
Add the following to your `.env` file:

#### For Twilio (Recommended)
```env
SMS_PROVIDER=twilio
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+1234567890
```

#### For AWS SNS
```env
SMS_PROVIDER=aws-sns
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_DEFAULT_REGION=us-east-1
```

#### For Development (Mock - No SMS sent)
```env
SMS_PROVIDER=mock
```

### 3. Install SMS Libraries (Optional)
If using Twilio:
```bash
composer require twilio/sdk
```

If using AWS SNS:
```bash
composer require aws/aws-sdk-php
```

## API Endpoints

### Send OTP
- **Worker**: `POST /api/worker/send-otp`
- **Employer**: `POST /api/employer/send-otp`

Request:
```json
{
  "phone": "9876543210"
}
```

Response:
```json
{
  "success": true,
  "message": "OTP sent successfully to 9876543210",
  "phone": "9876543210"
}
```

### Verify OTP
- **Worker**: `POST /api/worker/verify-otp`
- **Employer**: `POST /api/employer/verify-otp`

Request:
```json
{
  "phone": "9876543210",
  "otp": "123456"
}
```

Response:
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "phone": "9876543210"
}
```

## Frontend Integration

The Vue components automatically use the backend OTP service:

### EmployerRegister.vue
- Calls `/api/employer/send-otp` on "Send OTP" button
- Calls `/api/employer/verify-otp` before registration
- Shows SMS delivery confirmation message

### WorkerRegister.vue
- Calls `/api/worker/send-otp` on "Send OTP" button
- Calls `/api/worker/verify-otp` before registration
- Shows SMS delivery confirmation message

### Forgot Password Flows
Both `EmployerForgotPassword.vue` and `WorkerFrogotPassword.vue`:
- Send OTP via SMS for password reset verification
- Clear OTP after successful verification

## SMS Message Template
```
Your OTP is: 123456. Valid for 10 minutes. Do not share with anyone.
```

## Error Handling

### Common Errors

**"Invalid or expired OTP"**
- OTP doesn't match the one sent
- OTP expired (over 10 minutes old)
- OTP already used

**"Failed to send OTP"**
- SMS provider credentials not configured
- Phone number in invalid format
- SMS provider service down

## Development & Testing

### Mock Provider (Development)
Set `SMS_PROVIDER=mock` in `.env`. OTP will be logged but not sent:
```
[2026-07-14 10:30:15] local.INFO: MOCK: OTP 456789 would be sent to 9876543210
```

### Testing with Real SMS
1. Set up Twilio/AWS SNS account
2. Add credentials to `.env`
3. Test with actual phone numbers
4. Check logs in `storage/logs/laravel.log`

## OTP Service Class
Location: `app/Services/OTPService.php`

Key methods:
- `generateOTP()`: Creates random 6-digit OTP
- `sendOTP($phone, $otp)`: Sends OTP via configured provider
- `storeOTP($user, $otp)`: Saves OTP to database with expiry
- `verifyOTP($user, $otp)`: Validates OTP
- `clearOTP($user)`: Removes OTP after successful use

## Security Considerations

1. **OTP Expiration**: OTPs expire after 10 minutes
2. **No Reuse**: OTP is cleared after successful verification
3. **Phone Validation**: Only 10-digit Indian phone numbers accepted
4. **Secure Storage**: OTPs stored in database (consider hashing in production)
5. **Rate Limiting**: Implement rate limiting for send-otp endpoints (recommended)

## Troubleshooting

### SMS Not Received
1. Check `SMS_PROVIDER` setting in `.env`
2. Verify SMS provider credentials
3. Check logs: `tail -f storage/logs/laravel.log`
4. Confirm phone number format (10 digits for India)

### "Class 'OTPService' not found"
- Run `composer dump-autoload`
- Check if `app/Services/OTPService.php` exists

### CORS Issues
- Already handled by Laravel CORS middleware
- Ensure `CORS_ALLOWED_ORIGINS` includes frontend URL

## Next Steps

1. Choose and configure an SMS provider (Twilio recommended)
2. Test OTP flow end-to-end
3. Implement rate limiting on OTP endpoints
4. Add OTP logs/analytics for monitoring
5. Consider OTP templating in SMS messages
6. Add admin dashboard for OTP verification stats

## References

- [Twilio PHP SDK](https://www.twilio.com/docs/libraries/php)
- [AWS SNS PHP SDK](https://docs.aws.amazon.com/sdk-for-php/)
- [Laravel Configuration](https://laravel.com/docs/configuration)
