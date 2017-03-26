import Constants  from '../constants';

const initialState = {
  channel: null,
  fetching: true,
  showUsersForm: false,
  error: false
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.CURRENT_BOARD_FETHING:
      return { ...state, fetching: true };

    case Constants.BOARDS_SET_CURRENT_BOARD:
      return { ...state, fetching: false, ...action.board };

    case Constants.CURRENT_BOARD_CONNECTED_TO_CHANNEL:
      return { ...state, channel: action.channel };

    case Constants.CURRENT_BOARD_SHOW_MEMBERS_FORM:
      return { ...state, showUsersForm: action.show, error: false };

    default:
      return state;
  }
}