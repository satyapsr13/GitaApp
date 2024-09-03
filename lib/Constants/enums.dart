enum Status {
  initial,
  loading,
  daySpecialLoading,
  loadingNextPage,
  categoryLoading,
  categoryError,
  updateSuccess,
  authSuccess,
  categorySuccess,
  showTodayModel,
  stickerLimitExceed,
  success,
  failure,
  phoneNumberInvalid, 
  play,
  plause,
  


}





enum AdStatus {
  initial,
  error,
  loaded,
  videoComplete,
}

enum ProfilePos {
  rightTouched,
  leftTouched,
  right,
  left,
}

enum EditorWidgets {
  none,
  profileSizeAndShape,
  dateText,
  playStoreBadge,
  stickerWidget,
  colorWidget,
  profileStaticPos
}

enum DatePos { none, topLeft, topRight, dragging }

enum Screen {
  gitaGyanScreen,
  editScreen,
  profileScreen,
  createPostScreen,
}
