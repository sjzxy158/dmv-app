class silversiriApi {
  static const baseUrl = 'https://api-dmv.silversiri.com';

  // 州列表
  static const getStateList = '$baseUrl/getStateList';

  // 测试题列表
  static const getTestsList = '$baseUrl/getTestsList';

  // Road Sign列表
  static const getRoadList = '$baseUrl/getRoadList';

  // Handbook
  static const getHandbookList = '$baseUrl/getHandbookList';
}

class productionApi {
  static const baseUrl = 'https://api.dmv-test-pro.com';

  // 州列表
  static const getStateList = '$baseUrl/getStateList';

  // 测试题列表
  static const getTestsList = '$baseUrl/getTestsList';

  // Road Sign列表
  static const getRoadList = '$baseUrl/getRoadList';

  // Handbook
  static const getHandbookList = '$baseUrl/getHandbookList';
}
