<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Shop extends Model
{
    protected $fillable = ['user_id', 'name', 'logo', 'banner', 'description'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function products()
    {
        return $this->hasMany(Product::class);
    }

    public function banners()
    {
        return $this->hasMany(Banner::class);
    }

    public function vouchers()
    {
        return $this->hasMany(Voucher::class);
    }

    public function followers()
    {
        return $this->belongsToMany(User::class, 'shop_followers');
    }
}
