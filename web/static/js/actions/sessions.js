import { push }                           from 'react-router-redux';
import Constants                          from '../constants';
import { Socket }                         from 'phoenix';
import { httpGet, httpPost, httpDelete }  from '../utils';

const Actions = {
  signIn: (email, password) => {
    return dispatch => {
      const data = {
        session: {
          email: email,
          password: password,
        },
      };

      httpPost('/api/v1/sessions', data)
        .then((data) => {
          localStorage.setItem('phoenixAuthToken', data.jwt);
          dispatch(push('/'));
        })
        .catch((error) => {
          error.response.json()
            .then((errorJSON) => {
              dispatch({
                type: Constants.SESSIONS_ERROR,
                error: errorJSON.error,
              });
            });
        });
    };
  },

  currentUser: () => {
    return dispatch => {
      const authToken = localStorage.getItem('phoenixAuthToken');

      httpGet('/api/v1/current_user')
        .catch(function (error) {
          console.log(error);
          dispatch(push('/sign_in'));
        });
    };
  },

  signOut: () => {
    return dispatch => {
      httpDelete('/api/v1/sessions')
        .then((data) => {
          localStorage.removeItem('phoenixAuthToken');

          dispatch({ type: Constants.USER_SIGNED_OUT, });

          dispatch(push('/sign_in'));

          dispatch({ type: Constants.BOARDS_FULL_RESET });
        })
        .catch(function (error) {
          console.log(error);
        });
    };
  },
};

export default Actions;