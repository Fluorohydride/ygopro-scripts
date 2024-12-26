--グッサリ＠イグニスター
---@param c Card
function c55762976.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55762976,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,55762976)
	e1:SetCondition(c55762976.spcon)
	e1:SetTarget(c55762976.sptg)
	e1:SetOperation(c55762976.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55762976,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,55762977)
	e2:SetCondition(c55762976.damcon)
	e2:SetTarget(c55762976.damtg)
	e2:SetOperation(c55762976.damop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55762976,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,55762978)
	e3:SetCondition(c55762976.atkcon)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c55762976.atkop)
	c:RegisterEffect(e3)
end
function c55762976.cfilter(c)
	return c:IsPreviousPosition(POS_FACEUP) and bit.band(c:GetPreviousTypeOnField(),TYPE_LINK)~=0 and c:IsReason(REASON_BATTLE)
end
function c55762976.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c55762976.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c55762976.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c55762976.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c55762976.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	local bc=nil
	if ec then
		bc=ec:GetBattleTarget()
		e:SetLabelObject(bc)
	end
	return bc and bc:GetBaseAttack()>0 and ec:IsType(TYPE_LINK) and ec:IsControler(tp) and ec:IsRelateToBattle()
		and ec:IsStatus(STATUS_OPPO_BATTLE)
end
function c55762976.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetTargetCard(bc)
	local dam=bc:GetBaseAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c55762976.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetBaseAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
function c55762976.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	if not ac:IsControler(tp) then ac,tc=tc,ac end
	return ac and ac:IsControler(tp) and ac:IsFaceup() and ac:IsType(TYPE_LINK) and tc and tc:IsControler(1-tp) and tc:IsFaceup()
end
function c55762976.atkfilter(c)
	return c:IsFaceup() and c:IsRelateToBattle()
end
function c55762976.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	local g=Group.FromCards(ac,tc):Filter(c55762976.atkfilter,nil)
	local gc=g:GetFirst()
	while gc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		gc:RegisterEffect(e1)
		gc=g:GetNext()
	end
end
