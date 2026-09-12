<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\Worker;
use App\Models\WorkerProfile;
use Illuminate\Foundation\Testing\RefreshDatabase;

class GetWorkerTest extends TestCase
{
    use RefreshDatabase;

    public function test_get_worker_returns_profile_with_skills()
    {
        $worker = Worker::create([
            'phone' => '9999999999',
            'password' => bcrypt('password'),
        ]);

        $profile = WorkerProfile::create([
            'worker_id' => $worker->id,
            'skill_id' => json_encode([1,2]),
        ]);

        $response = $this->getJson('/api/worker/' . $worker->id);

        $response->assertStatus(200);
        $response->assertJsonStructure(['worker' => ['profile' => ['skills']]]);
    }
}
