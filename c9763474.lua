--Haggard Lizardose
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.accost)
	e1:SetTarget(s.actg)
	e1:SetOperation(s.acop)
	c:RegisterEffect(e1)
end
function s.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function s.atkcheck(c,atk)
	return c:IsFaceup() and c:GetAttack()~=atk
end
function s.cfilter(c)
	return c:IsAttackBelow(2000) and c:GetTextAttack()>=0 and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
		and (Duel.IsPlayerCanDraw(c:GetControler(),1) or c:GetOriginalRace()~=RACE_REPTILE)
		and Duel.IsExistingTarget(s.atkcheck,0,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetBaseAttack())
end
function s.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabel(tc:GetBaseAttack(),tc:GetOriginalRace())
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local atk,race=e:GetLabel()
	if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and chkc:GetAttack()~=atk end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.atkcheck,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,atk)
	if race==RACE_REPTILE then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk,race=e:GetLabel()
	if tc:IsType(TYPE_MONSTER) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()~=atk then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
		if race==RACE_REPTILE then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
