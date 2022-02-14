<?php

namespace App\Http\Controllers;

use App\Models\Device;
use App\Models\EventDatum;
use App\Models\Geozone;
use App\Models\GeozoneAlertModel;
use App\Models\GeozoneAlertSettings;
use App\Models\Notification;
use App\Models\NotificationHistorics;
use Illuminate\Http\Request;


class GeozoneAlertContoller extends Controller
{


    public function  settings(Request $request)
    {

        $fields = $request->validate(['notification_id' => 'required|numeric']);

        $settings =   GeozoneAlertSettings::where('notification_id', $fields['notification_id'])->first();

        if ($settings == null) {
            $settings =  GeozoneAlertSettings::create(
                [
                    'notification_id' => $fields['notification_id'],
                    'is_active' => false
                ]
            );
        }

        return $settings;
    }

    public function  updateSettings(Request $request)
    {
        $fields = $request->validate(
            [
                'notification_id' => 'required|numeric',
                'is_active' => 'required|boolean'
            ]
        );
        GeozoneAlertSettings::where('notification_id', $fields['notification_id'])->update(
            [
                'is_active' => $fields['is_active'],
            ]
        );
    }

    static  public  function sendNotification()
    {

        $settings = GeozoneAlertSettings::where('is_active', true)->where('notification_id', 2230)->get();
        foreach ($settings as $setting) {
            $notifParam =   Notification::find($setting->notification_id);
            if ($notifParam == null) continue;
            // khasni nchuf wach chi device khraj wla dkhal man dok geozone lidrt
            // fetch geozone li3nd dak compte
            $geozones = Geozone::where('accountID', $notifParam->accountID)->get();
            if (!$geozones->isEmpty()) {
                $devices = Device::where('accountID', $notifParam->accountID)->get();
                foreach ($devices as $device) {
                    // db hna 3ndi lat o long dyal device khasni nchuf wach dakhl f chi geozone
                    foreach ($geozones as $geozone) {
                        if ($geozone->zoneType == 0) {
                            $isInside = AlertController::vincentyGreatCircleDistance($geozone->latitude1, $geozone->longitude1, $device->lastValidLatitude, $device->lastValidLongitude) <= $geozone->radius;

                            // circle 
                            if (($geozone->sortID == 0 || $geozone->sortID == 2) && $isInside) {
                                // TODO :: check historic if the notification already sent

                                if ($geozone->sortID == 2) {
                                    GeozoneAlertModel::where('device_id', $device->deviceID)
                                        ->where('account_id', $device->accountID)
                                        ->where('geozone_id', $geozone->geozoneID)
                                        ->where('type', 1)
                                        ->where('state', false)
                                        ->orderBy('updated_at', 'desc')
                                        ->limit(1)->update(
                                            [
                                                'state' => true
                                            ]
                                        );
                                }



                                $histo = GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 0)
                                    ->orderBy('updated_at', 'desc')->first();



                                if (($histo != null && $histo->state == false)) {
                                    continue;
                                };

                                print_r("Inside circle {$geozone->description}  ---  {$device->description}\n");
                                $date = date('d/m/Y H:i',  $device->lastEventTimestamp);
                                $message = [
                                    'notification_id' => $notifParam->id,
                                    'title' => "$device->description entré geozone",
                                    'body' => "Geozone: {$geozone->geozoneID}\nDate: $date",
                                    'device_id' => $notifParam->deviceID,
                                    'account_id' => $device->accountID,
                                ];

                                $event = EventDatum::where('accountID', $device->accountID)
                                    ->where('deviceID', $device->deviceID)
                                    ->where('timestamp', $device->lastEventTimestamp)->first();
                                GeozoneAlertModel::create([
                                    'device_id' => $device->deviceID,
                                    'account_id' => $device->accountID,
                                    'geozone_id' => $geozone->geozoneID,
                                    'timestamp' => $event?->timestamp ?? 0,
                                    'address' => $event?->address ?? '',
                                    'type' => 0,
                                    'state' => false,
                                ]);




                                WebNotificationController::sendWebNotificationFindByID($message);
                            } else if (($geozone->sortID == 2 || $geozone->sortID == 0) && !$isInside) {

                                if ($geozone->sortID == 0) {
                                    GeozoneAlertModel::where('device_id', $device->deviceID)
                                        ->where('account_id', $device->accountID)
                                        ->where('geozone_id', $geozone->geozoneID)
                                        ->where('type', 0)
                                        ->where('state', false)
                                        ->orderBy('updated_at', 'desc')
                                        ->limit(1)->update(
                                            [
                                                'state' => true
                                            ]
                                        );
                                    continue;
                                }

                                $histo = GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 1)
                                    ->orderBy('updated_at', 'desc')
                                    ->first();


                                if (($histo != null && $histo->state == false)) {
                                    continue;
                                };



                                print_r("Outside circle {$geozone->description}  ---  {$device->description}\n");
                                $date = date('d/m/Y H:i',  $device->lastEventTimestamp);
                                $message = [
                                    'notification_id' => $notifParam->id,
                                    'title' => "$device->description sortie geozone",
                                    'body' => "Geozone: {$geozone->geozoneID}\nDate: $date",
                                    'device_id' => $notifParam->deviceID,
                                    'account_id' => $device->accountID,
                                ];

                                $event = EventDatum::where('accountID', $device->accountID)
                                    ->where('deviceID', $device->deviceID)
                                    ->where('timestamp', $device->lastEventTimestamp)->first();

                                GeozoneAlertModel::create([
                                    'device_id' => $device->deviceID,
                                    'account_id' => $device->accountID,
                                    'geozone_id' => $geozone->geozoneID,
                                    'timestamp' => $event?->timestamp ?? 0,
                                    'address' => $event?->address ?? '',
                                    'type' => 1,
                                    'state' => false,
                                ]);

                                GeozoneAlertModel::where('device_id', $device->deviceID)
                                ->where('account_id', $device->accountID)
                                ->where('geozone_id', $geozone->geozoneID)
                                ->where('type', 0)
                                ->where('state', false)
                                ->orderBy('updated_at', 'desc')
                                ->limit(1)->update(
                                    [
                                        'state' => true
                                    ]
                                );
                                WebNotificationController::sendWebNotificationFindByID($message);
                            } else if (!$isInside && ($geozone->sortID == 1 || $geozone->sortID == 2)) {
                                $histo = GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 1)
                                    ->orderBy('updated_at', 'desc')->first();





                                if ($histo != null && $histo->state == false) continue;

                                $date = date('d/m/Y H:i',  $device->lastEventTimestamp);
                                $message = [
                                    'notification_id' => $notifParam->id,
                                    'title' => "$device->description sortie geozone",
                                    'body' => "Geozone: {$geozone->geozoneID}\nDate: $date",
                                    'device_id' => $notifParam->deviceID,
                                    'account_id' => $device->accountID,

                                ];

                                WebNotificationController::sendWebNotificationFindByID($message);

                                $event = EventDatum::where('accountID', $device->accountID)
                                    ->where('deviceID', $device->deviceID)
                                    ->where('timestamp', $device->lastEventTimestamp)->first();
                                GeozoneAlertModel::create([
                                    'device_id' => $device->deviceID,
                                    'account_id' => $device->accountID,
                                    'geozone_id' => $geozone->geozoneID,
                                    'timestamp' => $event?->timestamp ?? 0,
                                    'address' => $event?->address ?? '',
                                    'type' => 1,
                                    'state' => false,
                                ]);
                                print_r("Outside circle  {$geozone->description}  ---  {$device->description}\n");
                            } else if ($isInside && ($geozone->sortID == 1 || $geozone->sortID == 2)) {
                                /*   $histo = GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 1)
                                    ->orderBy('updated_at', 'desc')
                                    ->first();
                                if ($geozone->sortID == 2 && ($histo == null || !$histo->state)) {
                                    $date = date('d/m/Y H:i',  $device->lastEventTimestamp);
                                    $message = [
                                        'notification_id' => $notifParam->id,
                                        'title' => "$device->description entrie geozone",
                                        'body' => "Geozone: {$geozone->geozoneID}\nDate: $date",
                                        'device_id' => $notifParam->deviceID,
                                        'account_id' => $device->accountID,
                                    ];
                                    WebNotificationController::sendWebNotificationFindByID($message);
                                } */
                                GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 1)
                                    ->where('state', false)
                                    ->orderBy('updated_at', 'desc')
                                    ->limit(1)->update(
                                        [
                                            'state' => true
                                        ]
                                    );
                            }
                        } else if ($geozone->zoneType == 1) {

                            $isInside = GeozoneAlertContoller::isInsidePolyGone($geozone, $device->lastValidLatitude, $device->lastValidLongitude);
                            if ($isInside && ($geozone->sortID == 0 || $geozone->sortID == 2)) {

                                $histo = GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 0)
                                    ->orderBy('updated_at', 'desc')
                                    ->first();

                                if ($histo != null && $histo->state == false) continue;

                                $date = date('d/m/Y H:i',  $device->lastEventTimestamp);
                                $message = [
                                    'notification_id' => $notifParam->id,
                                    'title' => "$device->description entré geozone",
                                    'body' => "Geozone: {$geozone->geozoneID}\nDate: $date",
                                    'device_id' => $notifParam->deviceID,
                                    'account_id' => $device->accountID,

                                ];

                                $event = EventDatum::where('accountID', $device->accountID)
                                    ->where('deviceID', $device->deviceID)
                                    ->where('timestamp', $device->lastEventTimestamp)->first();
                                GeozoneAlertModel::create([
                                    'device_id' => $device->deviceID,
                                    'account_id' => $device->accountID,
                                    'geozone_id' => $geozone->geozoneID,
                                    'timestamp' => $event?->timestamp ?? 0,
                                    'address' => $event?->address ?? '',
                                    'type' => 0,
                                    'state' => false,
                                ]);
                                WebNotificationController::sendWebNotificationFindByID($message);
                                print_r("Inside polygone {$geozone->description}  ---  {$device->description}\n");
                            } else if (!$isInside && ($geozone->sortID == 0 || $geozone->sortID == 2)) {
                                $histo = GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 0)
                                    ->orderBy('updated_at', 'desc')
                                    ->first();
                                /*                                if ($geozone->sortID == 2 && ($histo == null || !$histo->state)) {
                                    $date = date('d/m/Y H:i',  $device->lastEventTimestamp);
                                    $message = [
                                        'notification_id' => $notifParam->id,
                                        'title' => "$device->description sortie geozone",
                                        'body' => "Geozone: {$geozone->geozoneID}\nDate: $date",
                                        'device_id' => $notifParam->deviceID,
                                        'account_id' => $device->accountID,
                                    ];

                                    $event = EventDatum::where('accountID', $device->accountID)
                                        ->where('deviceID', $device->deviceID)
                                        ->where('timestamp', $device->lastEventTimestamp)->first();
                                    GeozoneAlertModel::create([
                                        'device_id' => $device->deviceID,
                                        'account_id' => $device->accountID,
                                        'geozone_id' => $geozone->geozoneID,
                                        'timestamp' => $event?->timestamp ?? 0,
                                        'address' => $event?->address ?? '',
                                        'type' => 0,
                                        'state' => false,
                                    ]);
                                    WebNotificationController::sendWebNotificationFindByID($message);
                                }*/
                                GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 0)
                                    ->where('state', false)
                                    ->orderBy('updated_at', 'desc')
                                    ->limit(1)->update(
                                        [
                                            'state' => true
                                        ]
                                    );
                            } else if (!$isInside && ($geozone->sortID == 1 || $geozone->sortID == 2)) {
                                $histo = GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 1)
                                    ->orderBy('updated_at', 'desc')
                                    ->first();
                                if ($histo != null  && $histo->state == false) continue;
                                $date = date('d/m/Y H:i',  $device->lastEventTimestamp);
                                $message = [
                                    'notification_id' => $notifParam->id,
                                    'title' => "$device->description sortie geozone",
                                    'body' => "Geozone: {$geozone->geozoneID}\nDate: $date",
                                    'device_id' => $notifParam->deviceID,
                                    'account_id' => $device->accountID,
                                ];
                                WebNotificationController::sendWebNotificationFindByID($message);

                                $event = EventDatum::where('accountID', $device->accountID)
                                    ->where('deviceID', $device->deviceID)
                                    ->where('timestamp', $device->lastEventTimestamp)->first();

                                GeozoneAlertModel::create([
                                    'device_id' => $device->deviceID,
                                    'account_id' => $device->accountID,
                                    'geozone_id' => $geozone->geozoneID,
                                    'timestamp' => $event?->timestamp ?? 0,
                                    'address' => $event?->address ?? '',
                                    'type' => 1,
                                    'state' => false
                                ]);
                                print_r("outside polygone {$geozone->description}  ---  {$device->description}\n");
                            } else if ($isInside && ($geozone->sortID == 1 || $geozone->sortID == 2)) {
                                /*   $histo = GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 1)
                                    ->orderBy('updated_at', 'desc')
                                    ->first();
                               if ($geozone->sortID == 2 && ($histo == null || !$histo->state)) {
                                    $date = date('d/m/Y H:i',  $device->lastEventTimestamp);
                                    $message = [
                                        'notification_id' => $notifParam->id,
                                        'title' => "$device->description entrie geozone",
                                        'body' => "Geozone: {$geozone->geozoneID}\nDate: $date",
                                        'device_id' => $notifParam->deviceID,
                                        'account_id' => $device->accountID,
                                    ];
                                    $event = EventDatum::where('accountID', $device->accountID)
                                        ->where('deviceID', $device->deviceID)
                                        ->where('timestamp', $device->lastEventTimestamp)->first();

                                    GeozoneAlertModel::create([
                                        'device_id' => $device->deviceID,
                                        'account_id' => $device->accountID,
                                        'geozone_id' => $geozone->geozoneID,
                                        'timestamp' => $event?->timestamp ?? 0,
                                        'address' => $event?->address ?? '',
                                        'type' => 1,
                                        'state' => false
                                    ]);
                                    WebNotificationController::sendWebNotificationFindByID($message);

                                }*/

                                GeozoneAlertModel::where('device_id', $device->deviceID)
                                    ->where('account_id', $device->accountID)
                                    ->where('geozone_id', $geozone->geozoneID)
                                    ->where('type', 1)
                                    ->where('state', false)
                                    ->orderBy('updated_at', 'desc')
                                    ->limit(1)->update(['state' => true]);
                            }
                        }
                    }
                }
            }
        }
    }


    static function isInsidePolyGone(Geozone $geozone, float $latitudeDevice, float $longitudeDevice)
    {


        $vertices_x = array();    // x-coordinates of the vertices of the polygon
        $vertices_y = array();

        if ($geozone->latitude10 != null) {
            array_push($vertices_x, $geozone->latitude1, $geozone->latitude2, $geozone->latitude3, $geozone->latitude4, $geozone->latitude5, $geozone->latitude6, $geozone->latitude7, $geozone->latitude8, $geozone->latitude9, $geozone->latitude10);
            array_push($vertices_y, $geozone->longitude1, $geozone->longitude2, $geozone->longitude3, $geozone->longitude4, $geozone->longitude5, $geozone->longitude6, $geozone->longitude7, $geozone->longitude8, $geozone->longitude9, $geozone->longitude10);
        } else if ($geozone->latitude9 != null) {
            array_push($vertices_x, $geozone->latitude1, $geozone->latitude2, $geozone->latitude3, $geozone->latitude4, $geozone->latitude5, $geozone->latitude6, $geozone->latitude7, $geozone->latitude8, $geozone->latitude9);
            array_push($vertices_y, $geozone->longitude1, $geozone->longitude2, $geozone->longitude3, $geozone->longitude4, $geozone->longitude5, $geozone->longitude6, $geozone->longitude7, $geozone->longitude8, $geozone->longitude9);
        } else if ($geozone->latitude8 != null) {
            array_push($vertices_x, $geozone->latitude1, $geozone->latitude2, $geozone->latitude3, $geozone->latitude4, $geozone->latitude5, $geozone->latitude6, $geozone->latitude7, $geozone->latitude8);
            array_push($vertices_y, $geozone->longitude1, $geozone->longitude2, $geozone->longitude3, $geozone->longitude4, $geozone->longitude5, $geozone->longitude6, $geozone->longitude7, $geozone->longitude8);
        } else if ($geozone->latitude7 != null) {
            array_push($vertices_x, $geozone->latitude1, $geozone->latitude2, $geozone->latitude3, $geozone->latitude4, $geozone->latitude5, $geozone->latitude6, $geozone->latitude7);
            array_push($vertices_y, $geozone->longitude1, $geozone->longitude2, $geozone->longitude3, $geozone->longitude4, $geozone->longitude5, $geozone->longitude6, $geozone->longitude7);
        } else if ($geozone->latitude6 != null) {
            array_push($vertices_x, $geozone->latitude1, $geozone->latitude2, $geozone->latitude3, $geozone->latitude4, $geozone->latitude5, $geozone->latitude6);
            array_push($vertices_y, $geozone->longitude1, $geozone->longitude2, $geozone->longitude3, $geozone->longitude4, $geozone->longitude5, $geozone->longitude6);
        } else if ($geozone->latitude5 != null) {
            array_push($vertices_x, $geozone->latitude1, $geozone->latitude2, $geozone->latitude3, $geozone->latitude4, $geozone->latitude5);
            array_push($vertices_y, $geozone->longitude1, $geozone->longitude2, $geozone->longitude3, $geozone->longitude4, $geozone->longitude5);
        } else if ($geozone->latitude4 != null) {
            array_push($vertices_x, $geozone->latitude1, $geozone->latitude2, $geozone->latitude3, $geozone->latitude4);
            array_push($vertices_y, $geozone->longitude1, $geozone->longitude2, $geozone->longitude3, $geozone->longitude4);
        } else if ($geozone->latitude3 != null) {
            array_push($vertices_x, $geozone->latitude1, $geozone->latitude2, $geozone->latitude3);
            array_push($vertices_y, $geozone->longitude1, $geozone->longitude2, $geozone->longitude3);
        } else {
            return false;
        }



        // y-coordinates of the vertices of the polygon
        $points_polygon = count($vertices_x) - 1;  // number vertices - zero-based array
        $longitude_x = $latitudeDevice;  // x-coordinate of the point to test
        $latitude_y = $longitudeDevice;    // y-coordinate of the point to test

        if (GeozoneAlertContoller::is_in_polygon($points_polygon, $vertices_x, $vertices_y, $longitude_x, $latitude_y)) {
            return true;
        } else echo false;
    }


    static function is_in_polygon($points_polygon, $vertices_x, $vertices_y, $longitude_x, $latitude_y)
    {
        $i = $j = $c = 0;
        for ($i = 0, $j = $points_polygon; $i < $points_polygon; $j = $i++) {
            if ((($vertices_y[$i]  >  $latitude_y != ($vertices_y[$j] > $latitude_y)) &&
                ($longitude_x < ($vertices_x[$j] - $vertices_x[$i]) * ($latitude_y - $vertices_y[$i]) / ($vertices_y[$j] - $vertices_y[$i]) + $vertices_x[$i])))
                $c = !$c;
        }
        return $c;
    }
    static  function isInside(
        $circle_x,
        $circle_y,
        $rad,
        $x,
        $y
    ) {
        // Compare radius of circle
        // with distance of its center
        // from given point
        if (($x - $circle_x) * ($x - $circle_x) +
            ($y - $circle_y) * ($y - $circle_y) <=
            $rad * $rad
        )
            return true;
        else
            return false;
    }

    static function calculeDistanceBetweenTowPoint(float $latA, float $longA, float $latB, float $longB)
    {
        $newlongA     = $longA * (M_PI / 180); // M_PI is a php constant
        $newlatA     = $latA * (M_PI / 180);
        $newlongB     = $longB * (M_PI / 180);
        $newlatB     = $latB * (M_PI / 180);

        $subBA       = bcsub($newlongB, $newlongA, 20);
        $cosLatA     = cos($newlatA);
        $cosLatB     = cos($newlatB);
        $sinLatA     = sin($newlatA);
        $sinLatB     = sin($newlatB);

        $distance = 6371 * acos($cosLatA * $cosLatB * cos($subBA) + $sinLatA * $sinLatB);
        return  $distance;
    }
}
