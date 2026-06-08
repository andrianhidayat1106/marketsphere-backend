<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FlashSaleItem extends Model
{
    public $timestamps = false;
    public $incrementing = false;

    protected $fillable = ['flash_sale_id', 'product_variant_id', 'discount_price', 'stock_allocated'];

    protected function casts(): array
    {
        return [
            'discount_price' => 'decimal:2',
            'stock_allocated' => 'integer',
        ];
    }

    public function flashSale()
    {
        return $this->belongsTo(FlashSale::class);
    }

    public function productVariant()
    {
        return $this->belongsTo(ProductVariant::class);
    }
}
