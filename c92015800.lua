--No.76 諧調光師グラディエール
function c92015800.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c92015800.attval)
	c:RegisterEffect(e1)
	--indes battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c92015800.indval1)
	c:RegisterEffect(e2)
	--indes effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c92015800.indval2)
	c:RegisterEffect(e3)
	--3rd: get material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(92015800,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,92015800)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetTarget(c92015800.xyztg)
	e4:SetOperation(c92015800.xyzop)
	c:RegisterEffect(e4)
end
aux.xyz_number[92015800]=76
function c92015800.effilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c92015800.attval(e,c)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local wg=og:Filter(c92015800.effilter,nil)
	local wbc=wg:GetFirst()
	local att=0
	while wbc do
		att=att|wbc:GetAttribute()
		wbc=wg:GetNext()
	end
	return att
end
function c92015800.indval1(e,c)
	return c:GetBattleTarget():GetAttribute()&c:GetAttribute()~=0
end
function c92015800.indval2(e,re,rp)
	if not (rp==1-e:GetHandlerPlayer() and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)) then return false end
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsControler(rp) and (rc:IsFaceup() or not rc:IsLocation(LOCATION_MZONE)) then
		return e:GetHandler():IsAttribute(rc:GetAttribute())
	else
		return e:GetHandler():IsAttribute(rc:GetOriginalAttribute())
	end
end
function c92015800.xyzfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c92015800.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c92015800.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c92015800.xyzfilter,tp,0,LOCATION_GRAVE,1,nil)
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c92015800.xyzfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c92015800.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) and tc:IsRelateToEffect(e) and tc:IsCanOverlay() then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
