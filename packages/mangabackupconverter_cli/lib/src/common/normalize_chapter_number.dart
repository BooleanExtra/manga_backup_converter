/// Strips float32→float64 promotion artifacts by formatting to 7 significant
/// digits (float32 precision) then re-parsing.
/// E.g. 1.100000023841858 → 1.1, 10.100000381469727 → 10.1
double normalizeChapterNumber(double value) {
  return double.parse(value.toStringAsPrecision(7));
}
