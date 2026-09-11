<?php

namespace App\Http\Controllers;

use App\Models\UserProfile;
use Illuminate\Http\Request;
use Tymon\JWTAuth\Facades\JWTAuth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Validator;
use App\Models\{User,Employer,EmployerProfile};

class EmployerController extends Controller
{

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'nullable|email|unique:employers,email',
            'phone' => 'required|digits:10|unique:employers,phone',
            'password' => 'required|string|min:6|max:10',
           // 'skills' => 'required|array',
           // 'skills.*' => 'exists:skills,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $user = Employer::create([
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
        ]);

        $profile = EmployerProfile::create([
            'name'=> $request->name,
            'employer_id' => $user->id,
            'avg_worker' => $request->avg_worker,
            'work_type' => $request->work_type,
            'location' => $request->location,
            'availability' => $request->availability,
            'eshram' => $request->eshram,
            'aadhar' => $request->aadhar,
            'bocw' => $request->bocw,
            'language' => $request->language,
        ]);

        if ($request->has('skills')) {
            $user->skills()->attach($request->skills);
        }

        $token = JWTAuth::fromUser($user);

        return response()->json([
            'message' => 'User registered successfully',
            'employer' => $user,
            'profile' => $profile,
            'skills' => $user->skills,
            'token' => $token
        ]);
    }



    public function login(Request $request)
    {
        // Validation: allow either password or otp for login
        $rules = ['phone' => 'required|string'];
        if ($request->has('otp')) {
            $rules['otp'] = 'required|digits:6';
        } else {
            $rules['password'] = 'required|string';
        }

        $request->validate($rules);

        // Find employer by phone
        $employer = Employer::where('phone', trim($request->phone))->first();

        if (!$employer) {
            return response()->json(['error' => 'Employer account not found'], 401);
        }

        // OTP-based login
        if ($request->has('otp')) {
            $otpService = new \App\Services\OTPService();

            if (!$otpService->verifyOTP($employer, $request->otp)) {
                return response()->json(['error' => 'Invalid or expired OTP'], 401);
            }

            // Clear OTP after successful verification
            $otpService->clearOTP($employer);

            $token = JWTAuth::fromUser($employer);

            return response()->json([
                'message' => 'Employer Login successful',
                'employer' => $employer,
                'token' => $token
            ]);
        }

        // Password-based login
        if (!Hash::check($request->password, $employer->password)) {
            return response()->json(['error' => 'Invalid credentials'], 401);
        }

        // Generate JWT token
        $token = JWTAuth::fromUser($employer);

        return response()->json([
            'message' => 'Employer Login successful',
            'employer' => $employer,
            'token' => $token
        ]);
    }

    public function updateEmployer(Request $request, $id)
        {
            $employer = Employer::find($id);

            if (!$employer) {
                return response()->json([
                    'status' => false,
                    'message' => 'Employer not found'
                ], 404);
            }

             $validator = Validator::make($request->all(), [
                'email' => 'nullable|email|unique:employers,email,' . $id,
                'phone' => 'sometimes|digits:10|unique:employers,phone,' . $id,
                'password' => 'sometimes|string|min:6|max:10',
                'name' => 'sometimes|string|max:255',
                'emp_type' => 'sometimes|string|max:255',
                'gender' => 'string|max:20', // ✅ added
                // ✅ Document fields
                'docType' => 'nullable|string|max:100',
                'docNumber' => 'nullable|string|max:50',
                 'pdf' => 'nullable|string',
                //'skill_id' => 'sometimes|numeric',
                'avg_worker' => 'sometimes|string|max:100',
                'work_type' => 'sometimes|string|max:100',
                'location' => 'sometimes|string|max:255',
                'availability' => 'sometimes|string|max:50',
                'eshram' => 'nullable|string|max:50',
                'aadhar' => 'nullable|string|max:12',
                'bocw' => 'nullable|string|max:50',
                'language' => 'nullable|string|max:100',
                'lat' => 'nullable|string',
                'long' => 'nullable|string',
                'plot_no' => 'nullable|string|max:255',
                'street_area_village' => 'nullable|string|max:255',
                'post_office' => 'nullable|string|max:255',
                'district' => 'nullable|string|max:255',
                'state' => 'nullable|string|max:255',
                'pin_code' => 'nullable|string|max:10',
                'profile_image' => 'nullable|string',
            ]);



            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'errors' => $validator->errors()
                ], 422);
            }

            // ✅ Update employer basic info
            if ($request->has('password')) {
                $employer->password = Hash::make($request->password);
            }
            if ($request->has('email')) {
                $employer->email = $request->email;
            }
            if ($request->has('phone')) {
                $employer->phone = $request->phone;
            }

            if ($request->has('skills')) {
                $skills = is_array($request->skills) ? $request->skills : [$request->skills];
                $employer->skills()->sync($skills);
            }
            $employer->save();
            $profile = EmployerProfile::where('employer_id', $id)->first();


            if ($profile) {
                $profile->update($request->only([
                    'name',
                    'avg_worker',
                    'work_type',
                    'location',
                    'lat',
                    'long',
                    'gender',
                    'availability',
                    'eshram',
                    'aadhar',
                    'bocw',
                    'language',
                    'plot_no',
                    'street_area_village',
                    'post_office',
                    'district',
                    'state',
                    'pin_code',
                    'docType',
                    'docNumber',
                    'emp_type'
                ]));

            // ✅ Upload directories from .env
            $uploadPath = env('UPLOAD_PATH_EMPLOYER');
            //$uploadPath = config('filesystems.paths.worker_upload');
            //image
            $imagePath= $uploadPath . '/profile';
            $docPath = $uploadPath . '/docs';
           // Log::info('Upload Path: ' . $uploadPath);
           // Log::info('Doc Path: ' . $docPath);

            if (!is_dir($imagePath)) {
                    mkdir($imagePath, 0777, true);
                }

                if (!is_dir($docPath)) {
                    mkdir($docPath, 0777, true);
                }

            // ✅ Handle Profile Image (Base64)
            if ($request->has('profile_image')) {
                $base64Image = $request->profile_image;

                if (preg_match('/^data:image\/(\w+);base64,/', $base64Image, $type)) {
                    $data = base64_decode(substr($base64Image, strpos($base64Image, ',') + 1));
                    $type = strtolower($type[1]);
                    $filename = time() . '.' . $type;

                    if ($data !== false) {
                        if ($profile->profile_image && file_exists($imagePath . '/' . $profile->profile_image)) {
                            unlink($imagePath . '/' . $profile->profile_image);
                        }
                        file_put_contents($imagePath . '/' . $filename, $data);
                        $profile->profile_image = $filename;
                    }
                }
            }

            // ✅ Handle PDF (Base64)
            if ($request->has('pdf')) {
                $base64Pdf = $request->pdf;

                if (preg_match('/^data:application\/pdf;base64,/', $base64Pdf)) {
                    $data = base64_decode(substr($base64Pdf, strpos($base64Pdf, ',') + 1));
                    $filename = time() . '.pdf';

                    if ($data !== false) {
                        if ($profile->pdf && file_exists($docPath . '/' . $profile->pdf)) {
                            unlink($docPath . '/' . $profile->pdf);
                        }
                        file_put_contents($docPath . '/' . $filename, $data);
                        $profile->pdf = $filename;
                    }
                }
            }

            $profile->save();

            }

            return response()->json([
                'status' => true,
                'message' => 'Employer & profile updated successfully',
                'employer' => $employer,
                'profile' => $profile
            ]);
        }


    public function changePassword(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'employer_id' => 'required|integer|exists:employers,id',
                'old_password' => 'required|string',
                'new_password' => 'required|string|min:6|max:12|confirmed',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                ], 422);
            }

            $employer = Employer::find($request->employer_id);

            if (!$employer) {
                return response()->json([
                    'success' => false,
                    'message' => 'Employer not found',
                ], 404);
            }

            if (!Hash::check($request->old_password, $employer->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Old password is incorrect',
                ], 400);
            }

            $employer->password = Hash::make($request->new_password);
            $employer->save();

            return response()->json([
                'success' => true,
                'message' => 'Password changed successfully',
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Something went wrong while changing password',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function forgotPassword(Request $request)
    {
        try {
            // ✅ Validate input
            $validator = Validator::make($request->all(), [
                'phone' => 'required|digits:10|exists:employers,phone',
                'password' => 'required|string|min:6|max:20',
                'otp' => 'required|digits:6',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                ], 422);
            }

            // ✅ Find employer by phone
            $employer = Employer::where('phone', $request->phone)->first();

            if (!$employer) {
                return response()->json([
                    'success' => false,
                    'message' => 'Employer not found with this phone number.',
                ], 404);
            }

            // ✅ Verify OTP before updating password
            $otpService = new \App\Services\OTPService();

            if (!$otpService->verifyOTP($employer, $request->otp)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid or expired OTP',
                ], 400);
            }

            // Clear OTP after successful verification
            $otpService->clearOTP($employer);

            // ✅ Update password securely
            $employer->password = Hash::make($request->password);
            $employer->save();

            return response()->json([
                'success' => true,
                'message' => 'Password updated successfully.',
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Something went wrong while updating password.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function sendOTP(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'phone' => 'required|digits:10',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                ], 422);
            }

            $phone = $request->phone;
            $otpService = new \App\Services\OTPService();

            // Find existing employer or create a temporary record for new registration
            $employer = Employer::where('phone', $phone)->first();
            
            if (!$employer) {
                // Keep the test OTP available until the employer is registered.
                Cache::put("employer_registration_otp:{$phone}", '123456', now()->addMinutes(10));

                return response()->json([
                    'success' => true,
                    'message' => 'OTP sent successfully',
                    'phone' => $phone,
                ], 200);
            }

            // Generate OTP
            $otp = "123456";//$otpService->generateOTP();

            // Store OTP in database
            $otpService->storeOTP($employer, $otp);

            // Send SMS
            $smsSent = $otpService->sendOTP($phone, $otp);

            if (!$smsSent) {
                return response()->json([
                    'success' => false,
                    'message' => 'Failed to send OTP. Please try again.',
                ], 500);
            }

            return response()->json([
                'success' => true,
                'message' => 'OTP sent successfully to ' . $phone,
                'phone' => $phone,
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error sending OTP',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function verifyOTP(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'phone' => 'required|digits:10',
                'otp' => 'required|digits:6',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                ], 422);
            }

            $employer = Employer::where('phone', $request->phone)->first();
            $otpService = new \App\Services\OTPService();

            // If employer doesn't exist yet (registration), check cache key
            if (!$employer) {
                $cacheKey = "employer_registration_otp:{$request->phone}";
                $registrationOtp = Cache::get($cacheKey);

                if (!$registrationOtp || !hash_equals($registrationOtp, (string) $request->otp)) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Invalid or expired OTP',
                    ], 400);
                }

                Cache::forget($cacheKey);

                return response()->json([
                    'success' => true,
                    'message' => 'OTP verified successfully',
                    'phone' => $request->phone,
                ], 200);
            }

            if (!$otpService->verifyOTP($employer, $request->otp)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid or expired OTP',
                ], 400);
            }

            // Clear OTP after successful verification
            $otpService->clearOTP($employer);

            return response()->json([
                'success' => true,
                'message' => 'OTP verified successfully',
                'phone' => $employer->phone,
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error verifying OTP',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

}
