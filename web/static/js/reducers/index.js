// @flow
import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import session from './session';
import boards from './boards';
import currentBoard from './current_board';

export default combineReducers({
  routing: routerReducer,
  session,
  boards,
  currentBoard
});
