String formatLegalId(String legalId) {
  if (legalId.length == 11) {
    return '${legalId.substring(0, 3)}.${legalId.substring(3, 6)}.${legalId.substring(6, 9)}-${legalId.substring(9, 11)}';
  } else if (legalId.length == 14) {
    return '${legalId.substring(0, 2)}.${legalId.substring(2, 5)}.${legalId.substring(5, 8)}/${legalId.substring(8, 12)}-${legalId.substring(12)}';
  }

  return legalId;
}
