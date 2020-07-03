--E－HERO マリシャス・デビル
function c86676862.initial_effect(c)
	aux.AddCodeList(c,94820406)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,58554959,c86676862.ffilter,1,true,true)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c86676862.splimit)
	c:RegisterEffect(e2)
	--Pos Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c86676862.poscon)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	--must attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e5:SetValue(c86676862.atklimit)
	c:RegisterEffect(e5)
end
c86676862.material_setcode=0x8
c86676862.dark_calling=true
function c86676862.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
		or Duel.IsPlayerAffectedByEffect(sp,72043279) and st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function c86676862.ffilter(c)
	return c:IsRace(RACE_FIEND) and c:IsLevelAbove(6)
end
function c86676862.poscon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
		and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c86676862.atklimit(e,c)
	return c==e:GetHandler()
end
