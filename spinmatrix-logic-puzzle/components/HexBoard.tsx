import React from 'react';
import { GEOMETRY } from '../utils/hexLogic';
import { HexGridState, HEX_COLOR_MAP } from '../types';
import { RotateCw, Sparkles } from 'lucide-react';

interface HexBoardProps {
  grid: HexGridState;
  onRotate: (rotatorId: number) => void;
  isInteractive: boolean;
  scale?: number;
  showRotators?: boolean;
}

const HexBoard: React.FC<HexBoardProps> = ({ 
  grid, 
  onRotate, 
  isInteractive,
  scale = 1,
  showRotators = true
}) => {
  // Fixed ViewBox
  const VIEW_SIZE = 300;
  
  // Helper to generate a curved path for a triangle
  // Pts: A, B, C. Center: G.
  // We want to curve edges AB, BC, CA outwards.
  const createPetalPath = (tId: number) => {
    const tri = GEOMETRY.triangles[tId];
    const { points, center } = tri;
    
    // Function to get a control point for edge P1-P2 that pushes away from Center
    // Actually, simpler aesthetic: Just use the midpoint pushed out?
    // Or just Draw A -> Q(Control) -> B.
    // Control point = Midpoint + (Midpoint - Center) * factor
    
    const getControl = (p1: {x:number, y:number}, p2: {x:number, y:number}) => {
      const mid = { x: (p1.x + p2.x)/2, y: (p1.y + p2.y)/2 };
      const vec = { x: mid.x - center.x, y: mid.y - center.y };
      // Push out slightly
      const factor = 0.2; 
      return { x: mid.x + vec.x * factor, y: mid.y + vec.y * factor };
    };

    const c1 = getControl(points[0], points[1]);
    const c2 = getControl(points[1], points[2]);
    const c3 = getControl(points[2], points[0]);

    return `
      M ${points[0].x},${points[0].y}
      Q ${c1.x},${c1.y} ${points[1].x},${points[1].y}
      Q ${c2.x},${c2.y} ${points[2].x},${points[2].y}
      Q ${c3.x},${c3.y} ${points[0].x},${points[0].y}
      Z
    `;
  };

  return (
    <div className="relative flex items-center justify-center">
       <svg 
        width={VIEW_SIZE * scale} 
        height={VIEW_SIZE * scale} 
        viewBox="-150 -150 300 300"
        className="drop-shadow-2xl overflow-visible"
       >
         <defs>
            <filter id="petal-glow">
                <feGaussianBlur in="SourceGraphic" stdDeviation="1" result="blur" />
                <feComposite in="SourceGraphic" in2="blur" operator="over" />
            </filter>
         </defs>

         {/* Render Triangles as Petals */}
         <g filter="url(#petal-glow)">
            {GEOMETRY.triangles.map((tri) => {
                const color = HEX_COLOR_MAP[grid[tri.id]];
                return (
                    <path
                        key={tri.id}
                        d={createPetalPath(tri.id)}
                        fill={color}
                        stroke="rgba(0,0,0,0.3)"
                        strokeWidth="1"
                        className="transition-all duration-300 ease-out hover:brightness-110"
                    />
                );
            })}
         </g>

         {/* Render Rotator Highlights */}
         {showRotators && GEOMETRY.rotators.map((rot) => (
           <g 
            key={rot.id} 
            onClick={() => isInteractive && onRotate(rot.id)}
            className={`${isInteractive ? 'cursor-pointer hover:opacity-100' : ''} opacity-0 transition-opacity duration-200 group`}
           >
             {/* Invisible Hit Area */}
             <circle cx={rot.center.x} cy={rot.center.y} r="15" fill="transparent" />
             
             {/* Visible Hover Indicator */}
             <circle 
                cx={rot.center.x} 
                cy={rot.center.y} 
                r="8" 
                fill="white" 
                className="group-hover:scale-125 transition-transform origin-center shadow-lg"
             />
             <foreignObject x={rot.center.x - 6} y={rot.center.y - 6} width="12" height="12" className="pointer-events-none">
                <div className="text-slate-900 flex items-center justify-center w-full h-full">
                    <RotateCw size={8} strokeWidth={4} />
                </div>
             </foreignObject>
             
             {/* Decorative Sparkle on Hover */}
             <foreignObject x={rot.center.x - 12} y={rot.center.y - 25} width="24" height="24" className="pointer-events-none opacity-0 group-hover:opacity-100 transition-opacity">
                 <div className="text-yellow-300 flex justify-center animate-spin-once">
                     <Sparkles size={16} />
                 </div>
             </foreignObject>
           </g>
         ))}
       </svg>
    </div>
  );
};

export default HexBoard;