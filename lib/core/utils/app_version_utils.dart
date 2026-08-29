class VersionUtils {
  static bool isLower(String current, String minimum) {
    final currentParts = _parse(current);
    final minimumParts = _parse(minimum);

    for (int i = 0; i < 3; i++) {
      if (currentParts[i] < minimumParts[i]) {
        return true;
      }

      if (currentParts[i] > minimumParts[i]) {
        return false;
      }
    }

    return false;
  }

  static List<int> _parse(String version) {
    final parts = version.split(".");

    return List.generate(
      3,
      (index) => index < parts.length ? int.tryParse(parts[index]) ?? 0 : 0,
    );
  }
}
