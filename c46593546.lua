--DDD赦俿王デス・マキナ
function c46593546.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),10,2,c46593546.ovfilter,aux.Stringid(46593546,0))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	c:SetUniqueOnField(1,0,46593546,LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46593546,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,46593546)
	e1:SetTarget(c46593546.sptg)
	e1:SetOperation(c46593546.spop)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46593546,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c46593546.ovlcon)
	e2:SetTarget(c46593546.ovltg)
	e2:SetOperation(c46593546.ovlop)
	c:RegisterEffect(e2)
	--to pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(46593546,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c46593546.pencon)
	e3:SetTarget(c46593546.pentg)
	e3:SetOperation(c46593546.penop)
	c:RegisterEffect(e3)
end
function c46593546.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10af)
end
function c46593546.sptgfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c46593546.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c46593546.sptgfilter(chkc) end
	local c=e:GetHandler()
	local tc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,c)
	if chk==0 then return tc and Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c46593546.sptgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(46593546,4))
	local g=Duel.SelectTarget(tp,c46593546.sptgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function c46593546.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,c)
	local fc=Duel.GetFirstTarget()
	if tc and Duel.GetMZoneCount(tp)>0
		and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and fc:IsRelateToEffect(e) then
		Duel.MoveToField(fc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c46593546.ovlcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsControler(1-tp) and rc:GetOriginalType()&TYPE_MONSTER~=0
		and (re:GetActivateLocation()&LOCATION_ONFIELD~=0 or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c46593546.ovltgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xae)
end
function c46593546.ovltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if chk==0 then return c:IsType(TYPE_XYZ)
		and (c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT)
			or Duel.IsExistingMatchingCard(c46593546.ovltgfilter,tp,LOCATION_ONFIELD,0,1,nil))
		and rc:IsRelateToEffect(re) and rc:IsCanBeXyzMaterial(c) end
end
function c46593546.ovlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local opt1=c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT)
	local opt2=Duel.IsExistingMatchingCard(c46593546.ovltgfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local result=0
	if not opt1 and not opt2 then return end
	if opt1 and not opt2 then result=0 end
	if opt2 and not opt1 then result=1 end
	if opt1 and opt2 then result=Duel.SelectOption(tp,aux.Stringid(46593546,5),aux.Stringid(46593546,6)) end
	if result==0 then
		result=c:RemoveOverlayCard(tp,2,2,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c46593546.ovltgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.HintSelection(g)
		result=Duel.Destroy(g,REASON_EFFECT)
	end
	if result>0 and c:IsRelateToEffect(e)
		and rc:IsRelateToEffect(re) and rc:IsControler(1-tp) and not rc:IsImmuneToEffect(e) then
		local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,rc)
	end
end
function c46593546.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c46593546.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c46593546.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
