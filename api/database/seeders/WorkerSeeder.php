<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Worker;
use App\Models\WorkerProfile;

class WorkerSeeder extends Seeder
{
    public function run(): void
    {
        // for ($i = 0; $i < 50; $i++) {

        //     // Create parent worker
        //     $worker = Worker::create([
        //         'email' => fake()->unique()->safeEmail(),
        //         'phone' => fake()->unique()->numerify('9#########'),
        //         'password' => bcrypt('password'),
        //     ]);

        //     // Create child worker_profile linked to worker_id
        //     WorkerProfile::create([
        //         'worker_id' => $worker->id,
        //         'name' => fake()->name(),
        //         'rate' => fake()->numberBetween(300, 1500),
        //         'age' => fake()->numberBetween(18, 55),

        //         // JSON field
        //         'skill_id' => [
        //             fake()->numberBetween(1, 10),
        //             fake()->numberBetween(11, 20),
        //         ],

        //         'experience' => fake()->numberBetween(1, 10),
        //         'work_type' => fake()->randomElement(['Daily Wage', 'Monthly']),
        //         'street_area_village' => fake()->streetName(),
        //         'pin_code' => fake()->numerify('######'),
        //         'district' => (string) fake()->numberBetween(1, 700),
        //         'state' => (string) fake()->numberBetween(1, 50),

        //         'availability' => fake()->randomElement(['Yes', 'No']),
        //         'gender' => fake()->randomElement(['male', 'female']),

        //         'lat' => fake()->latitude(20.0, 30.0),
        //         'long' => fake()->longitude(70.0, 90.0),

        //         'profile_image' => null,
        //     ]);
        // }
    }
}
