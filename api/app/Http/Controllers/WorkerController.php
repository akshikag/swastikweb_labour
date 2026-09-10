<?php

namespace App\Http\Controllers;

use App\Models\{User, Worker, WorkerProfile};
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Tymon\JWTAuth\Facades\JWTAuth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Validator;

class WorkerController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'nullable|email|unique:workers,email',
            'phone' => 'required|digits:10|unique:workers,phone',
            'password' => 'required|string|min:6|max:10',
            'age' => 'nullable|integer|min:0',
            'experience' => 'nullable|numeric|min:0',
        ]);

        // Ensure age is greater than experience when both provided
        $validator->after(function ($validator) use ($request) {
            if ($request->filled('age') && $request->filled('experience')) {
                $age = (int) $request->input('age');
                $exp = (float) $request->input('experience');
                if ($age <= $exp) {
                    $validator->errors()->add('age', 'Age must be greater than experience');
                }
            }
        });

        if ($validator->fails()) { 
            return response()->json([
                'status' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $user = Worker::create([
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
        ]);

        $profile = WorkerProfile::create([
            'name' => $request->name,
            'worker_id' => $user->id,
            'skill_id' => array_values(array_filter($request->skill_id ?? [])),
            'other_skills' => $request->other_skills ?? null,
        ]);

        $token = JWTAuth::fromUser($user);

        return response()->json([
            'message' => 'User registered successfully',
            'worker' => $user,
            'profile' => $profile,
            'token' => $token
        ]);
    }

  public function login(Request $request)
{
    $validated = $request->validate([
        'phone' => ['required', 'string'],
        'password' => ['required', 'string'],
    ]);

    $phone = trim($validated['phone']);

    $worker = Worker::where('phone', $phone)->first();

    if (!$worker) {
        return response()->json([
            'success' => false,
            'message' => 'Worker account was not found for this phone number.',
        ], 401);
    }

    if (!Hash::check($validated['password'], $worker->password)) {
        return response()->json([
            'success' => false,
            'message' => 'The password is incorrect.',
        ], 401);
    }

    $token = JWTAuth::fromUser($worker);

    return response()->json([
        'success' => true,
        'message' => 'Login successful.',
        'worker' => $worker,
        'token' => $token,
    ]);
}

    public function updateWorker(Request $request, $id)
    {
        if ($request->has("docNumber")) {
            $request->merge([
                "docNumber" => strtoupper(preg_replace("/[-\s]/", "", trim((string) $request->docNumber))),
            ]);
        }
        $worker = Worker::find($id);

        if (!$worker) {
            return response()->json([
                'status' => false,
                'message' => 'Worker not found'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'email' => 'nullable|email|unique:workers,email,' . $id,
            'phone' => 'sometimes|digits:10|unique:workers,phone,' . $id,
            'password' => 'sometimes|string|min:6|max:10',
            'name' => 'sometimes|string|max:255',
            'age' => 'sometimes|integer|min:0',
            'gender' => 'sometimes|string|max:20',
            'skill_id' => 'sometimes|array',
            'experience' => 'sometimes|numeric|min:0',
            'work_type' => 'sometimes|string|max:100',
            'location' => 'sometimes|string|max:255',
            'availability' => 'sometimes|string|max:50',
            'eshram' => 'nullable|string|max:50',
            'bocw' => 'nullable|string|max:50',
            'language' => 'nullable|string|max:100',
            'plot_no' => 'nullable|string|max:255',
            'street_area_village' => 'nullable|string|max:255',
            'post_office' => 'nullable|string|max:255',
            'district' => 'nullable|string|max:255',
            'state' => 'nullable|string|max:255',
            'pin_code' => 'nullable|string|max:10',
            'profile_image' => 'nullable|string',
            'docType' => 'sometimes|required|in:pancard,driving_license,voterid',
            'docNumber' => 'sometimes|required|string|max:20',
            'pdf' => 'nullable|string',
            'rate' => 'nullable|string|max:50',
            'other_skills' => 'nullable|string',
            'lat' => 'nullable|string',
            'long' => 'nullable|string',
        ]);

        $validator->sometimes("docNumber", "regex:/^[A-Z]{5}[0-9]{4}[A-Z]$/", fn ($input) => $input->docType === "pancard");
        $validator->sometimes("docNumber", "regex:/^[A-Z]{2}[0-9]{13}$/", fn ($input) => $input->docType === "driving_license");
        $validator->sometimes("docNumber", "regex:/^[A-Z]{3}[0-9]{7}$/", fn ($input) => $input->docType === "voterid");

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // Additional check: if both age and experience provided, age must be greater than experience
        if ($request->filled('age') && $request->filled('experience')) {
            $age = (int) $request->input('age');
            $exp = (float) $request->input('experience');
            if ($age <= $exp) {
                return response()->json([
                    'status' => false,
                    'errors' => ['age' => ['Age must be greater than experience']]
                ], 422);
            }
        }

        // ✅ Update Worker basic info
        if ($request->has('password')) $worker->password = Hash::make($request->password);
        if ($request->has('email')) $worker->email = $request->email;
        if ($request->has('phone')) $worker->phone = $request->phone;
        $worker->save();

        $profile = WorkerProfile::where('worker_id', $id)->first();

        if ($profile) {
            $profile->update($request->only([
                'name', 'age', 'gender', 'experience', 'work_type',
                'location', 'availability', 'eshram', 'bocw', 'language',
                'plot_no', 'street_area_village', 'post_office', 'district',
                'state', 'pin_code', 'docType', 'docNumber', 'rate','lat',
        'long'
            ]));

            if ($request->has('skill_id')) {
                $profile->skill_id = array_values(array_filter($request->skill_id ?? []));
            }

            if ($request->has('other_skills')) {
                $profile->other_skills = trim((string) $request->other_skills);
            }

            // ✅ Upload directories from .env
            $uploadPath = trim(env('UPLOAD_PATH_WORKER', 'upload/worker'), '/');
            $imagePath = public_path($uploadPath . '/profile');
            $docPath = public_path($uploadPath . '/docs');

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
            'message' => 'Worker & profile updated successfully',
            'worker' => $worker,
            'profile' => $profile
        ]);
    }

    public function getWorker($id)
    {
        $worker = Worker::with(['profile', 'profile.stateDetail', 'profile.districtDetail'])->find($id);

        if (!$worker) {
            return response()->json([
                'status' => false,
                'message' => 'Worker not found'
            ], 404);
        }

        $profile = $worker->profile;
        $skills = $profile->skills ?? [];
        $worker->profile['skills'] = $skills;



        return response()->json([
            'status' => true,
            'message' => 'Worker profile fetched successfully',
            'worker' => $worker
        ]);
    }

    public function changePassword(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'worker_id' => 'required|integer|exists:workers,id',
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

            $worker = Worker::find($request->worker_id);

            if (!Hash::check($request->old_password, $worker->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Old password is incorrect',
                ], 400);
            }

            $worker->password = Hash::make($request->new_password);
            $worker->save();

            return response()->json([
                'success' => true,
                'message' => 'Password changed successfully',
            ], 200);
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
            $validator = Validator::make($request->all(), [
                'phone' => 'required|digits:10|exists:workers,phone',
                'password' => 'required|string|min:6|max:20',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                ], 422);
            }

            $worker = Worker::where('phone', $request->phone)->first();
            $worker->password = Hash::make($request->password);
            $worker->save();

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

            if ($otpService->hasManualOTP()) {
                return response()->json([
                    'success' => true,
                    'message' => 'Manual OTP is ready',
                    'phone' => $phone,
                ], 200);
            }

            // Find existing worker or create a temporary record for new registration
            $worker = Worker::where('phone', $phone)->first();
            
            if (!$worker) {
                // Keep the test OTP available until the worker is registered.
                Cache::put("worker_registration_otp:{$phone}", '123456', now()->addMinutes(10));

                return response()->json([
                    'success' => true,
                    'message' => 'OTP sent successfully',
                    'phone' => $phone,
                ], 200);
            }

            // Generate OTP
            $otp = $otpService->generateOTP();

            // Store OTP in database
            $otpService->storeOTP($worker, $otp);

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

            $otpService = new \App\Services\OTPService();

            if ($otpService->verifyManualOTP((string) $request->otp)) {
                return response()->json([
                    'success' => true,
                    'message' => 'OTP verified successfully',
                    'phone' => $request->phone,
                ], 200);
            }

            $worker = Worker::where('phone', $request->phone)->first();

            if (!$worker) {
                $cacheKey = "worker_registration_otp:{$request->phone}";
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

            if (!$otpService->verifyOTP($worker, $request->otp)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid or expired OTP',
                ], 400);
            }

            // Clear OTP after successful verification
            $otpService->clearOTP($worker);

            return response()->json([
                'success' => true,
                'message' => 'OTP verified successfully',
                'phone' => $worker->phone,
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
