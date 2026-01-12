--DDカウント・サーベイヤー
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--release
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(s.rlcon)
	e1:SetTarget(s.rltg)
	e1:SetOperation(s.rlop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SEARCH|CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,id+o)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function s.rlcfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x10af) and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.rlcfilter,1,nil,tp)
end
function s.rlfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function s.gcheck(g)
	return (Auxiliary.SameValueCheck(g,Card.GetRace) or Auxiliary.SameValueCheck(g,Card.GetAttribute))
		and g:IsExists(s.atkfilter,1,nil,g)
end
function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.rlfilter,tp,0,LOCATION_MZONE,nil,e)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(s.gcheck,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,s.gcheck,false,3,3)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,sg,2,0,0)
end
function s.atkfilter(c,g)
	local sg=g:Clone()
	sg:Sub(Group.FromCards(c))
	return sg:FilterCount(Card.IsReleasableByEffect,nil)==2
end
function s.crlfilteer(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(s.crlfilteer,nil,e)
	if tg:GetCount()~=3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local sg=tg:FilterSelect(tp,s.atkfilter,1,1,nil,g)
	if sg:GetCount()>0 then
		tg:Sub(sg)
		Duel.HintSelection(tg)
		local rc=Duel.Release(tg,REASON_EFFECT)
		if rc>0 then
			local rg=Duel.GetOperatedGroup()
			local atk=rg:GetSum(Card.GetPreviousAttackOnField)
			local def=rg:GetSum(Card.GetPreviousDefenseOnField)
			local tc=sg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(def)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf) and c:IsDiscardable()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.thfilter(c)
	return c:IsSetCard(0xaf) and c:IsType(TYPE_MONSTER)
		and (c:IsAttack(0) or c:IsDefense(0)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
