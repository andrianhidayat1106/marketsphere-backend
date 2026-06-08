<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Voucher extends Model
{
    protected $fillable = ['shop_id', 'code', 'discount_type', 'discount_amount', 'min_purchase', 'valid_from', 'valid_until'];

    protected function casts(): array
    {
        return [
            'discount_amount' => 'decimal:2',
            'min_purchase' => 'decimal:2',
            'valid_from' => 'datetime',
            'valid_until' => 'datetime',
        ];
    }

    public function shop()
    {
        return $this->belongsTo(Shop::class);
    }
}
