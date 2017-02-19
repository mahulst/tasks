// @flow
import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';


const mapStateToProps = state => ({
  currentUser: state.session.currentUser
});

class RegistrationsNew extends React.Component {

  render() {
    return (
      <div className="view-container registrations new" />
    );
  }
}

export default connect(mapStateToProps)(RegistrationsNew);
