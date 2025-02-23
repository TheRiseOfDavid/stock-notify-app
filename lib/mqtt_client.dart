import 'package:flutter/widgets.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';

// XXX: mqtt5 這個 package 目前接收中文字時會發生問題，但 mqtt3 沒問題

const url = '<mqtt broken ip>'; //主機位置
const port = 1883; //MQTT port
const clientID = '<client ID>'; //Mqtt Client
const username = '<client username>'; //Mqtt username
const password = '<client password'; //Mqtt password

final client = MqttServerClient(url, clientID);

Future<MqttServerClient?> mqttClientConnect() async {
  client.port = port;
  client.logging(on: true);
  debugPrint("${client.port}");

  await client.connect(username, password);

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    debugPrint("mqtt is connect.");
  } else {
    debugPrint(
      'Error client connection failed, the state is ${client.connectionStatus?.state}',
    );
    client.disconnect();
    return null;
  }
  client.subscribe("TXF", MqttQos.atLeastOnce);

  client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final message = c[0].payload as MqttPublishMessage;
    final payload = MqttUtilities.bytesToStringAsString(
      message.payload.message!,
    );
    debugPrint('${c[0].topic}:${payload}');
  });
  return client;
}
