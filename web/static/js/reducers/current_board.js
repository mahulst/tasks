import Constants  from '../constants';

const initialState = {
  channel: null,
  fetching: true,
  showForm: false,
  showUsersForm: false,
  error: false,
  members: [],
  addingNewCardInListId: null
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

    case Constants.CURRENT_BOARD_MEMBER_ADDED:
      return { ...state, members: [...state.members, action.user]};

    case Constants.CURRENT_BOARD_SHOW_FORM:
      return { ...state, showForm: action.show};

    case Constants.CURRENT_BOARD_SHOW_CARD_FORM_FOR_LIST:
      return { ...state, addingNewCardInListId: action.listId };

    case Constants.CURRENT_BOARD_CARD_CREATED:
      let lists = state.lists;
      const { card } = action;

      const listIndex = lists.findIndex((list) => { return list.id === card.list_id; });
      lists[listIndex].cards.push(card);

      return { ...state, lists: lists };
    default:
      return state;
  }
}