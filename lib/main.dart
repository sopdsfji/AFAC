import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart'; //네이버 지도 library
import 'package:geolocator/geolocator.dart'; // geolocator
//import 'package:location/location.dart'; //위치서비스
import 'package:stop_watch_timer/stop_watch_timer.dart'; //stopwatch

void _getCurrentLocation() async {
  final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print('현재위치: $position');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await NaverMapSdk.instance.initialize(clientId: '758uozhof7');
  runApp(MyApp());
}
//지도 초기화
//https://daino.tistory.com/5#article-1--%EB%9D%BC%EC%9D%B4%EB%B8%8C%EB%9F%AC%EB%A6%AC-%EC%B6%94%EA%B0%80

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  //상단배너제거
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TwoSpot',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late NaverMapController controller;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); //create instance

  double s_la=0.0;
  double s_long=0.0;
  double a_la=0.0;
  double a_long=0.0;

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'TwoSpot',
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
                initialCameraPosition:  NCameraPosition(
                  target: NLatLng(37.451, 127.1291),
                  zoom: 14,
                  bearing:90,
                  tilt: 0,
                )
            ),
            onMapReady: (controller) {
              this.controller = controller;
              print("네이버 맵 로딩됨!");
              // // <마커 추가
              // final marker = NMarker(
              //     id: 'test',
              //     position:
              //     NLatLng(37.4506, 127.1267));
              // final marker1 = NMarker(
              //     id: 'test1',
              //     position:
              //     NLatLng(37.4551, 127.1335));
              // controller.addOverlayAll({marker, marker1});
              //
              // // final onMarkerInfoWindow =
              // // NInfoWindow.onMarker(id: marker.info.id, text: "멋쟁이 사자처럼");
              // // marker.openInfoWindow(onMarkerInfoWindow);
              // // 마커 추가>
            },
          ),

          StopWatch(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: (){
                  // 버튼이 눌렸을때 수행할 작업
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('출발지 입력'),
                          content: Container(
                            width: 200,
                            height: 200,
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  // controller: myController1,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(hintText: "위도"),
                                  onSubmitted: (value){
                                    setState(() {
                                      s_la = double.parse(value);
                                      print('출발지의 위도: $s_la');
                                    });
                                  },
                                ),
                                TextField(
                                  // controller: myController2,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(hintText: "경도"),
                                  onSubmitted: (value){
                                    setState(() {
                                      s_long = double.parse(value);
                                      print('출발지의 경도: $s_long');
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FloatingActionButton(
                              child: Text('확인'),
                              onPressed: (){
                                print('적용됨');
                                Navigator.of(context).pop();
                                // if(s_la != null && s_long != null){
                                //   this.controller.addOverlay(NMarker(
                                //       id: 'test',
                                //       position:
                                //       NLatLng(s_la, s_long)
                                //   ));
                                // }
                                // 희근이가 알려준 방안

                                // final marker = NMarker(
                                //     id: 'test',
                                //     position:
                                //     NLatLng(s_la, s_long));

                                NMarker marker = NMarker(
                                    id: 'start',
                                    position: NLatLng(s_la,s_long)
                                );
                                this.controller.addOverlay(marker);


                              },
                            ),
                          ],
                        );
                      }
                  );
                  print('출발지 버튼이 눌림.');
                },
                child: Text('출발지'),
              ),
            ),
          ), //출발지 버튼
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: (){
                  // 버튼이 눌렸을때 수행할 작업
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('도착지 입력'),
                          content: Container(
                            width: 200,
                            height: 200,
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  // controller: myController3,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(hintText: "위도"),
                                  onSubmitted: (value){
                                    setState(() {
                                      a_la = double.parse(value);
                                      print('도착지의 위도: $a_la');
                                    });
                                  },
                                ),
                                TextField(
                                  // controller: myController4,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(hintText: "경도"),
                                  onSubmitted: (value){
                                    setState(() {
                                      a_long = double.parse(value);
                                      print('도착지의 경도: $a_long');
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FloatingActionButton(
                              child: Text('확인'),
                              onPressed: (){
                                print('적용됨');
                                Navigator.of(context).pop();

                                NMarker marker = NMarker(
                                    id: 'arrive',
                                    position: NLatLng(a_la,a_long)
                                );
                                this.controller.addOverlay(marker);

                              },
                            ),
                          ],
                        );
                      }
                  );
                  print('도착지 버튼이 눌림.');
                },
                child: Text('도착지'),
              ),
            ),
          ), //도착지 버튼
        ], // children
      ),

    );
  }
}


// stopwatch 입력받는 코드
class StopWatch extends StatefulWidget {
  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {

  final Stopwatch _stopwatch = Stopwatch();
  final Duration _refreshRate = Duration(milliseconds: 30);
  Timer? _timer;


  void startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(_refreshRate, _updateTime);
  }

  void stopTimer() {
    _stopwatch.stop();
  }

  void resetTimer() {
    stopTimer();
    _stopwatch.reset();
    setState(() {});
  }

  void _updateTime(Timer timer) {
    if (!_stopwatch.isRunning) return;
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch?.stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final elapsedTime = _stopwatch.elapsed;
    return Positioned(
      top: 5.0,
      left: 5.0,
      child: Column(
        children: [
          Text(
            '${elapsedTime.inMinutes}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}.${(elapsedTime.inMilliseconds % 1000 / 10).toStringAsFixed(0).padLeft(2, '0')}',
            style: TextStyle(fontSize: 54),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: startTimer,
                child: Text('Start'),
              ),
              ElevatedButton(
                onPressed: stopTimer,
                child: Text('Stop'),
              ),
              ElevatedButton(
                onPressed: resetTimer,
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

}