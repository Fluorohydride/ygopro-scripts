--覇王門零
---@param c Card
function c96227613.initial_effect(c)
	aux.AddCodeList(c,13331639)
	aux.EnablePendulumAttribute(c)
	--avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c96227613.ndcon)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e0)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96227613,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c96227613.thcon)
	e2:SetTarget(c96227613.thtg)
	e2:SetOperation(c96227613.thop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(96227613,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c96227613.sptg)
	e3:SetOperation(c96227613.spop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(96227613,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c96227613.pencon)
	e4:SetTarget(c96227613.pentg)
	e4:SetOperation(c96227613.penop)
	c:RegisterEffect(e4)
end
function c96227613.ndcfilter(c)
	return c:IsFaceup() and c:IsCode(13331639)
end
function c96227613.ndcon(e)
	return Duel.IsExistingMatchingCard(c96227613.ndcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c96227613.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),22211622)
end
function c96227613.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x46) and c:IsAbleToHand()
end
function c96227613.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96227613.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c96227613.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if g:GetCount()<2 then return end
	if Duel.Destroy(g,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c96227613.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c96227613.desfilter(c,ec,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c96227613.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c,ec))
end
function c96227613.spfilter(c,e,tp,mg)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c96227613.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c96227613.desfilter(chkc,c,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c96227613.desfilter,tp,LOCATION_ONFIELD,0,1,c,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c96227613.desfilter,tp,LOCATION_ONFIELD,0,1,1,c,c,e,tp)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c96227613.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local dg=Group.FromCards(c,tc)
	if Duel.Destroy(dg,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c96227613.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
		if g:GetCount()==0 then return end
		local sc=g:GetFirst()
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
			sc:RegisterEffect(e4,true)
			local e5=e3:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e5:SetValue(1)
			sc:RegisterEffect(e5,true)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			sc:RegisterEffect(e6,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c96227613.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c96227613.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c96227613.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
