<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FlashSale extends Model
{
    public $timestamps = false;

    protected $fillable = ['title', 'start_time', 'end_time', 'is_active'];

    protected function casts(): array
    {
        return [
            'start_time' => 'datetime',
            'end_time' => 'datetime',
            'is_active' => 'boolean',
        ];
    }

    public function items()
    {
        return $this->hasMany(FlashSaleItem::class);
    }
}
