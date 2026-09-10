<?php

namespace App\Http\Controllers;

use App\Models\Skill;
use Illuminate\Http\Request;
use App\Models\WorkerHistory;
use Illuminate\Support\Facades\Validator;

class WorkerHistoryController extends Controller
{
    /**
     * 🟢 1. List all histories (optionally by worker)
     */
    public function index(Request $request)
    {
        try {
            // Check if worker_id is provided
            if (!$request->has('worker_id') || empty($request->worker_id)) {
                return response()->json([
                    'success' => false,
                    'message' => 'No data found',
                    'data' => []
                ], 200);
            }

            $query = WorkerHistory::with(['worker', 'employer'])
                ->where('worker_id', $request->worker_id);

            $histories = $query->orderBy('created_at', 'desc')->get();

            // Add skill names
            foreach ($histories as $history) {
                $skillIds = is_string($history->skill_id)
                    ? json_decode($history->skill_id, true)
                    : $history->skill_id;

                if (!empty($skillIds)) {
                    $history->skills = Skill::whereIn('id', $skillIds)
                        ->pluck('name')
                        ->toArray();
                } else {
                    $history->skills = [];
                }
            }

            return response()->json([
                'success' => true,
                'data' => $histories
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Something went wrong',
                'error' => $e->getMessage()
            ], 500);
        }

    }

    /**
     * 🟢 2. Create new history record
     */
    public function store(Request $request)
    {
        try {
            $rules = [
                'worker_id' => 'required|exists:workers,id',
                'employer_id' => 'nullable|exists:employers,id',
                'employer_name'=> 'nullable|string|max:255',
                'project_name' => 'nullable|string|max:255',
                'work_place' => 'nullable|string|max:255',
                'work_type' => 'nullable|string|max:255',
                'skill_id' => 'nullable|array',
                'task_description' => 'nullable|string',
                'start_date' => 'nullable|date',
                'end_date' => 'nullable|date',
                'days_worked' => 'nullable|integer',
                'daily_wage' => 'nullable|numeric',
                'total_amount' => 'nullable|numeric',
                'payment_status' => 'nullable|in:pending,paid,partial',
                'remarks' => 'nullable|string',
                'rating' => 'nullable|integer|min:1|max:5',
            ];

            $input = $request->all();

            // If client sent an array of histories, validate and create all entries
            if (is_array($input) && isset($input[0]) && is_array($input[0])) {
                $created = [];
                $errors = [];

                foreach ($input as $idx => $item) {
                    $validator = Validator::make($item, $rules);
                    if ($validator->fails()) {
                        $errors[$idx] = $validator->errors()->all();
                        continue;
                    }
                    $created[] = WorkerHistory::create($validator->validated());
                }

                if (empty($created)) {
                    return response()->json([
                        'success' => false,
                        'message' => 'No valid records to create',
                        'errors' => $errors
                    ], 422);
                }

                return response()->json([
                    'success' => true,
                    'message' => 'Worker histories added successfully',
                    'data' => $created,
                    'errors' => $errors
                ], 201);
            }

            // Single record
            $data = $request->validate($rules);

            $history = WorkerHistory::create($data);

            return response()->json([
                'success' => true,
                'message' => 'Worker history added successfully',
                'data' => $history
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create history',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * 🟢 3. Show single history record
     */
    public function show($id)
    {
        try {
            $history = WorkerHistory::with(['worker', 'employer'])->find($id);

            if (!$history) {
                return response()->json([
                    'success' => false,
                    'message' => 'Record not found'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => $history
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Something went wrong',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * 🟢 4. Update history record
     */
    public function update(Request $request, $id)
    {
        try {
            $history = WorkerHistory::find($id);

            if (!$history) {
                return response()->json([
                    'success' => false,
                    'message' => 'Record not found'
                ], 404);
            }

            $data = $request->validate([
                'project_name' => 'nullable|string|max:255',
                'work_place' => 'nullable|string|max:255',
                'work_type' => 'nullable|string|max:255',
                'skill_id' => 'nullable|integer',
                'task_description' => 'nullable|string',
                'start_date' => 'nullable|date',
                'end_date' => 'nullable|date',
                'days_worked' => 'nullable|integer',
                'daily_wage' => 'nullable|numeric',
                'total_amount' => 'nullable|numeric',
                'payment_status' => 'nullable|in:pending,paid,partial',
                'remarks' => 'nullable|string',
                'rating' => 'nullable|integer|min:1|max:5',
            ]);

            $history->update($data);

            return response()->json([
                'success' => true,
                'message' => 'Worker history updated successfully',
                'data' => $history
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update record',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * 🟢 5. Delete record
     */
    public function destroy($id)
    {
        try {
            $history = WorkerHistory::find($id);

            if (!$history) {
                return response()->json([
                    'success' => false,
                    'message' => 'Record not found'
                ], 404);
            }

            $history->delete();

            return response()->json([
                'success' => true,
                'message' => 'Worker history deleted successfully'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete record',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
