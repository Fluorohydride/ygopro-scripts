--FNo.0 未来皇ホープ－フューチャー・スラッシュ
function c43490025.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c43490025.xyzcon)
	e1:SetOperation(c43490025.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c43490025.atkval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--multi attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(43490025,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c43490025.atkcon)
	e4:SetCost(c43490025.atkcost)
	e4:SetTarget(c43490025.atktg)
	e4:SetOperation(c43490025.atkop)
	c:RegisterEffect(e4)
end
c43490025.xyz_number=0
function c43490025.ovfilter(c,xyzc)
	return c:IsFaceup() and (c:IsSetCard(0x107f) or c:IsCode(65305468)) and c:IsCanBeXyzMaterial(xyzc)
end
function c43490025.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and not c:IsSetCard(0x48) and c:IsCanBeXyzMaterial(xyzc)
end
function c43490025.xyzfilter1(c,g)
	return g:IsExists(c43490025.xyzfilter2,1,c,c:GetRank())
end
function c43490025.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c43490025.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if 2<=ct then return false end
	if min and (min>2 or max<2) then return false end
	local mg=nil
	local altmg=nil
	if og then
		mg=og:Filter(c43490025.mfilter,nil,c)
		altmg=og
	else
		mg=Duel.GetMatchingGroup(c43490025.mfilter,tp,LOCATION_MZONE,0,nil,c)
		altmg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	if ct<1 and (not min or min<=1) and altmg:IsExists(c43490025.ovfilter,1,nil,c) then
		return true
	end
	return mg:IsExists(c43490025.xyzfilter1,1,nil,mg)
end
function c43490025.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	local sg=Group.CreateGroup()
	if og and not min then
		g=og
		local tc=og:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(g)
		Duel.Overlay(c,g)
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct=-ft
		local mg=nil
		local altmg=nil
		if og then
			mg=og:Filter(c43490025.mfilter,nil,c)
			altmg=og
		else
			mg=Duel.GetMatchingGroup(c43490025.mfilter,tp,LOCATION_MZONE,0,nil,c)
			altmg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		end
		local b1=mg:IsExists(c43490025.xyzfilter1,1,nil,mg)
		local b2=ct<1 and (not min or min<=1) and altmg:IsExists(c43490025.ovfilter,1,nil,c)
		local g=nil
		if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(43490025,1))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			g=altmg:FilterSelect(tp,c43490025.ovfilter,1,1,nil,c)
			local g2=g:GetFirst():GetOverlayGroup()
			if g2:GetCount()~=0 then
				Duel.Overlay(c,g2)
			end
			c:SetMaterial(g)
			Duel.Overlay(c,g)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			g=mg:FilterSelect(tp,c43490025.xyzfilter1,1,1,nil,mg)
			local tc1=g:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g2=mg:FilterSelect(tp,c43490025.xyzfilter2,1,1,tc1,tc1:GetRank())
			local tc2=g2:GetFirst()
			g:Merge(g2)
			sg:Merge(tc1:GetOverlayGroup())
			sg:Merge(tc2:GetOverlayGroup())
			Duel.SendtoGrave(sg,REASON_RULE)
			Duel.Overlay(c,g)
		end
	end
end
function c43490025.atkfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function c43490025.atkval(e,c)
	return Duel.GetMatchingGroupCount(c43490025.atkfilter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*500
end
function c43490025.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c43490025.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c43490025.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c43490025.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
