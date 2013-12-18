axis tight
ax=axis;
axmarg=diff(ax).*0.05; %axmarg(1) is the horizontal padding, ax(3) is the vertical padding
ax(1)=ax(1)-axmarg(1);
ax(2)=ax(2)+axmarg(1);
ax(3)=ax(3)-axmarg(3);
ax(4)=ax(4)+axmarg(3);
axis(ax);
