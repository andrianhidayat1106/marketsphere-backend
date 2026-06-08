<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Address extends Model
{
    protected $fillable = [
        'user_id', 'label', 'receiver_name', 'phone_number', 'address_detail',
        'province_id', 'regency_id', 'district_id', 'village_id', 'postal_code', 'is_primary'
    ];

    protected function casts(): array
    {
        return [
            'is_primary' => 'boolean',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
