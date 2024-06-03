--覇王黒竜オッドアイズ・リベリオン・エクシーズ・ドラゴン
function c30095833.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_PENDULUM),7,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--can not be xyz material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetCondition(c30095833.xyzcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--pzone specialsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,30095833)
	e1:SetTarget(c30095833.sptg)
	e1:SetOperation(c30095833.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30095833,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,30095834)
	e2:SetCost(c30095833.descost)
	e2:SetTarget(c30095833.destg)
	e2:SetOperation(c30095833.desop)
	c:RegisterEffect(e2)
	--pendulum move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(30095833,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c30095833.pencon)
	e3:SetTarget(c30095833.pentg)
	e3:SetOperation(c30095833.penop)
	c:RegisterEffect(e3)
end
c30095833.pendulum_level=7
function c30095833.xyzcon(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c30095833.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanOverlay()
end
function c30095833.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c30095833.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if c:IsType(TYPE_XYZ)
		and Duel.GetMatchingGroupCount(aux.NecroValleyFilter(c30095833.mfilter),tp,LOCATION_GRAVE,0,nil)>0
		and Duel.SelectYesNo(tp,aux.Stringid(30095833,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c30095833.mfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Overlay(c,g)
	end
end
function c30095833.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c30095833.filter(c)
	return c:IsFaceup() and c:IsAttackBelow(3000)
end
function c30095833.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c30095833.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c30095833.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c30095833.filter,tp,0,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c30095833.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c30095833.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c30095833.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c30095833.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
