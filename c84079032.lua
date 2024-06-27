--面子蝙蝠
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(3,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(s.poscon2)
	e3:SetTarget(s.postg2)
	e3:SetOperation(s.posop2)
	c:RegisterEffect(e3)
end
s.toss_coin=true
function s.filter(c,e,tp)
	return c:IsCanChangePosition() and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_MZONE) and c:IsSummonPlayer(1-tp)
		and (not c:IsPosition(POS_FACEUP_ATTACK) or c:IsCanTurnSet())
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.filter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(s.filter,1,nil,e,tp) and not eg:IsContains(e:GetHandler(),tp) end
	local tc=eg:FilterSelect(tp,s.filter,1,1,nil,e,tp)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsCanChangePosition() then
		local c1=Duel.TossCoin(tp,1)
		if c1==1 and not tc:IsPosition(POS_FACEUP_ATTACK) then
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		elseif c1==0 and not tc:IsPosition(POS_FACEDOWN_DEFENSE) then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	end
end
function s.cfilter(c)
	return c:IsPreviousPosition(POS_FACEDOWN) and c:IsFaceup() and (not c:IsPosition(POS_FACEUP_ATTACK) or c:IsCanTurnSet())
		or c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown()
end
function s.poscon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.postg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.cfilter(chkc) and eg:IsContains(chkc) end
	if chk==0 then return eg:Filter(Card.IsOnField,nil):IsExists(s.cfilter,1,nil,e) and not eg:IsContains(e:GetHandler(),tp) end
	local tc=eg:Filter(Card.IsOnField,nil):FilterSelect(tp,s.cfilter,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
end
function s.posop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if tc:IsPosition(POS_FACEUP_ATTACK) then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		elseif tc:IsPosition(POS_FACEDOWN_DEFENSE) then
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		elseif tc:IsCanTurnSet() then
			local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
			Duel.ChangePosition(tc,pos)
		else
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
	end
end
