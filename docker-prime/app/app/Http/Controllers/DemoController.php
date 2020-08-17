<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;

class DemoController
{

    public function index()
    {
        if ($titlesData = Cache::store('redis')->get('titlesData')) {
            return response()->json($titlesData);
        }

        $titlesData = DB::table('titles')->select(DB::raw('*'))->get();

        Cache::store('redis')->put('titlesData', $titlesData, 600);

        return response()->json($titlesData);
    }

    public function ping()
    {

        return response()->json([
           'app_name' => config('app.name'),
            'response' => sprintf('pong from %s', config('app.name'))
        ]);

    }

}
