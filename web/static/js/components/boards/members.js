import React, {PropTypes}       from 'react';
import ReactGravatar            from 'react-gravatar';
import classnames               from 'classnames';
import PageClick                from 'react-page-click';
import Actions                  from '../../actions/current_board';

export default class BoardMembers extends React.Component {
  _renderUsers() {
    return this.props.members.map((member) => {
      return (
        <li key={member.id}>
          <ReactGravatar className="react-gravatar" email={member.email} https/>
        </li>
      );
    });
  }

  _renderAddNewUser() {
    if (!this.props.currentUserIsOwner) return false;

    return (
      <li>
        <a onClick={::this._handleAddNewClick} className="add-new" href="#"><i className="fa fa-plus"/> add new </a>
        {::this._renderForm()}
      </li>
    );
  }

  _renderForm() {
    if (!this.props.show) return false;

    return (
      <PageClick onClick={::this._handleCancelClick}>
        <ul className="drop-down active">
          <li>
            <form onSubmit={::this._handleSubmit}>
              <h4>Add new members</h4>
              {::this._renderError()}
              <input ref="email" type="email" required={true} value="michel2@test.nl" placeholder="Member email"/>
              <button type="submit">Add member</button> or <a onClick={::this._handleCancelClick} href="#">cancel</a>
            </form>
          </li>
        </ul>
      </PageClick>
    );
  }

  _renderError() {
    const { error } = this.props;

    if (!error) return false;

    return (
      <div className="error">
        {error}
      </div>
    );
  }

  _handleAddNewClick(e) {
    e.preventDefault();

    this.props.dispatch(Actions.showMembersForm(true));
  }

  _handleCancelClick(e) {
    e.preventDefault();

    this.props.dispatch(Actions.showMembersForm(false));
  }

  _handleSubmit(e) {
    e.preventDefault();

    const { email } = this.refs;
    const { dispatch, channel } = this.props;

    dispatch(Actions.addNewMember(channel, email.value));
  }

  render() {
    return (
      <ul className="board-users">
        {::this._renderUsers()}
        {::this._renderAddNewUser()}
      </ul>
    );
  }
}