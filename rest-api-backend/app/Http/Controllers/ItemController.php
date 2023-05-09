<?php

namespace App\Http\Controllers;

use App\Models\Item;
use Illuminate\Http\Request;

class ItemController extends Controller
{
    public function index()
    {
        $items = Item::all();
        return response()->json($items);
    }

    public function show($id)
    {
        $item = Item::find($id);
        return response()->json($item);
    }

    public function store(Request $request)
    {
        $item = new Item;
        $item->nama = $request->nama;
        $item->jumlah = $request->jumlah;
        $item->save();
        return response()->json($item);
    }

    public function update(Request $request, $id)
    {
        $item = Item::find($id);
        $item->nama = $request->nama;
        $item->jumlah = $request->jumlah;
        $item->save();
        return response()->json($item);
    }

    public function destroy($id)
    {
        $item = Item::find($id);
        $item->delete();
        return response()->json('Item deleted successfully');
    }
}
