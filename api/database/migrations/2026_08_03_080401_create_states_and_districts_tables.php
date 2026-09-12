<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('states', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('lgd_code')->unique();
            $table->string('state_name', 100);
            $table->timestamps();
        });
        Schema::create('districts', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('state_id')->index();
            $table->unsignedBigInteger('lgd_code')->unique();
            $table->string('district_name', 100);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('districts');
    }
};
