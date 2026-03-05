'use client';

import React from 'react';
import { motion } from 'framer-motion';

export const EnergyGrid = () => {
  return (
    <div className="absolute inset-0 z-0 overflow-hidden pointer-events-none">
      {/* The Original Grid Style */}
      <div 
        className="absolute inset-0 opacity-[0.03] dark:opacity-[0.07]" 
        style={{ 
          backgroundImage: 'linear-gradient(#fff 1px, transparent 1px), linear-gradient(90deg, #fff 1px, transparent 1px)', 
          backgroundSize: '40px 40px' 
        }} 
      />

      {/* Animated Electric Pulses along the grid lines */}
      <svg className="absolute inset-0 w-full h-full opacity-20 dark:opacity-40">
        <defs>
          <linearGradient id="electric-v" x1="0%" y1="0%" x2="0%" y2="100%">
            <stop offset="0%" stopColor="transparent" />
            <stop offset="50%" stopColor="#3b82f6" />
            <stop offset="100%" stopColor="transparent" />
          </linearGradient>
          <linearGradient id="electric-h" x1="0%" y1="0%" x2="100%" y2="0%">
            <stop offset="0%" stopColor="transparent" />
            <stop offset="50%" stopColor="#3b82f6" />
            <stop offset="100%" stopColor="transparent" />
          </linearGradient>
        </defs>

        {/* Vertical Pulses (Matching 40px grid) */}
        {[...Array(20)].map((_, i) => (
          <motion.rect
            key={`v-${i}`}
            width="1.5"
            height="120"
            x={`${(i * 5) + 2.5}%`}
            fill="url(#electric-v)"
            initial={{ y: "-20%", opacity: 0 }}
            animate={{ 
              y: ["0%", "100%"],
              opacity: [0, 1, 1, 0]
            }}
            transition={{
              duration: Math.random() * 4 + 3,
              repeat: Infinity,
              delay: Math.random() * 10,
              ease: "easeInOut"
            }}
          />
        ))}

        {/* Horizontal Pulses (Matching 40px grid) */}
        {[...Array(20)].map((_, i) => (
          <motion.rect
            key={`h-${i}`}
            width="120"
            height="1.5"
            y={`${(i * 5) + 2.5}%`}
            fill="url(#electric-h)"
            initial={{ x: "-20%", opacity: 0 }}
            animate={{ 
              x: ["0%", "100%"],
              opacity: [0, 1, 1, 0]
            }}
            transition={{
              duration: Math.random() * 4 + 3,
              repeat: Infinity,
              delay: Math.random() * 10,
              ease: "easeInOut"
            }}
          />
        ))}
      </svg>

      {/* Subtle Glow at intersections */}
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_50%,rgba(37,99,235,0.05),transparent_70%)]" />
    </div>
  );
};
