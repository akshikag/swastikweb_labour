<?php

namespace App\Models;

use App\Models\Skill;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class WorkerProfile extends Model
{
    use HasFactory;

     protected $appends = ['profile_image_url','skill_names','combined_skill_names'];


    protected $fillable = [
        'worker_id',
        'name',
        'age',
        'skill_id',
        'experience',
        'work_type',
        'location',
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
        'profile_image',
        'other_skills',
        'gender',
        'docType',
        'docNumber',
        'dob',
        'pdf',
        'rate',
        'lat',
        'long'
    ];

    protected $casts = [
        'skill_id' => 'array',
        'other_skills' => 'string',
        'dob' => 'date',
    ];

   public function worker()
    {
        return $this->belongsTo(Worker::class);
    }

     public function stateDetail()
    {
        return $this->belongsTo(State::class, 'state', 'lgd_code');
    }

    // ✅ Relationship with District
    public function districtDetail()
    {
        return $this->belongsTo(District::class, 'district', 'lgd_code');
    }


     // Custom accessor to get skill models
    public function getSkillsAttribute()
    {
        if (empty($this->skill_id)) {
            return collect();
        }

        return Skill::whereIn('id', $this->skill_id)->get();
    }


    public function getSkillNamesAttribute()
    {
        $ids = $this->skill_id ?? [];

        return \DB::table('skills')
            ->whereIn('id', $ids)
            ->pluck('name')
            ->toArray();
    }

    // Return combined skill names including any 'other_skills' entered by worker
    public function getCombinedSkillNamesAttribute()
    {
        $names = $this->skill_names ?? [];
        if (!empty($this->other_skills)) {
            // split by comma and trim
            $others = array_map('trim', explode(',', $this->other_skills));
            $names = array_merge($names, $others);
        }
        return $names;
    }

    public function getProfileImageUrlAttribute()
    {
        // If no image stored
        if (empty($this->profile_image)) {
            return url('default/no-photos.png');
        }

        // Create full URL
        $path = env('UPLOAD_PATH_WORKER').'/profile/';
        return url($path . $this->profile_image);
    }


//      public function skill()
//     {
//         return $this->belongsTo(Skill::class, 'skill_id');
//     }
 }
