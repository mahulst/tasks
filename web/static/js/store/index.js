/* @flow */
import { createStore, applyMiddleware, compose } from 'redux';
import { routerMiddleware } from 'react-router-redux';
import createLogger from 'redux-logger';
import thunkMiddleware from 'redux-thunk';
import reducers from '../reducers';

const loggerMiddleware = createLogger({
  level: 'info',
  collapsed: true,
});

export default function configureStore(browserHistory: Object) {

  const reduxRouterMiddleware = routerMiddleware(browserHistory);

  const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;
  const enhancer = composeEnhancers(
      applyMiddleware(
      reduxRouterMiddleware,
      thunkMiddleware,
      loggerMiddleware,
    )
  );

  return createStore(reducers, enhancer);
}
