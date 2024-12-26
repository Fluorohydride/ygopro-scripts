--覇王眷竜ダーク・リベリオン
---@param c Card
function c42160203.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c42160203.matfilter,4,2)
	--change atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(42160203,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCountLimit(1)
	e1:SetCondition(c42160203.atkcon)
	e1:SetCost(c42160203.atkcost)
	e1:SetOperation(c42160203.atkop)
	c:RegisterEffect(e1)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(42160203,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_BATTLE_START)
	e4:SetCondition(c42160203.spcon)
	e4:SetCost(c42160203.spcost)
	e4:SetTarget(c42160203.sptg)
	e4:SetOperation(c42160203.spop)
	c:RegisterEffect(e4)
end
function c42160203.matfilter(c)
	return c:IsXyzType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c42160203.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and bc:GetAttack()>0
end
function c42160203.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c42160203.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if tc:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetValue(atk)
			c:RegisterEffect(e2)
		end
	end
end
function c42160203.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c42160203.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function c42160203.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x10f8,0x20f8)
		and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c42160203.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),TYPE_PENDULUM)>0
		and Duel.IsExistingMatchingCard(c42160203.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c42160203.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	if ft==0 then return end
	ft=math.min(ft,2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		ft=1
	end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c42160203.spfilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
