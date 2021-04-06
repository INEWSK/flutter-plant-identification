class RestApi {
  /// azure
  static const String azureUrl = 'https://florabackend.azurewebsites.net';
  // local測試
  static const String localUrl = 'http://10.0.2.2:8000';
  // vtc 內聯網
  static const String vtcUrl = '192.168.20.81:80/api';

  static const String signIn = "$localUrl/flora/signIn";
  static const String signUp = "$localUrl/flora/signUp";
  static const String aiLabel = "$localUrl/flora/tree-ai-labels";
  static const String aiRetrain = "$localUrl/flora/tree-ai-retrain";
  static const String treeAI = "$localUrl/flora/tree-ai";
  static const String tree = "$localUrl/flora/tree";
}
