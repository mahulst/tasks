// @flow
import React from 'react';
type Props = {
  children: Object
}

export default function MainLayout(props: Props) {
  return (
    <div>
      {props.children}
    </div>
  );
}
MainLayout.propTypes = {
  children: React.PropTypes.element.isRequired,
};
