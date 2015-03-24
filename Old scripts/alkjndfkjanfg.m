Surf = 0;
for m = 1:size(pv.faces,1)
    x1(1) = 160*pv.vertices(pv.faces(m,1),1); x1(2) = 160*pv.vertices(pv.faces(m,1),2); x1(3) = 160*pv.vertices(pv.faces(m,1),3);
    x2(1) = 160*pv.vertices(pv.faces(m,2),1); x2(2) = 160*pv.vertices(pv.faces(m,2),2); x2(3) = 160*pv.vertices(pv.faces(m,2),3);
    x3(1) = 160*pv.vertices(pv.faces(m,3),1); x3(2) = 160*pv.vertices(pv.faces(m,3),2); x3(3) = 160*pv.vertices(pv.faces(m,3),3);
    Surf = Surf + 0.5*norm(cross((x2-x1),(x1-x3)));
end