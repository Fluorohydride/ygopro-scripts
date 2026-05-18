--刻まれし魔の大聖棺
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	-- fusion summon
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_GRAVE,
		mat_operation_code_map={
			{ [LOCATION_DECK]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_SHUFFLE }
		},
		extra_target=s.extra_target
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	-- equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
end

function s.lcheck(g)
	return g:IsExists(s.mfilter,1,nil)
end

function s.mfilter(c)
	return c:IsLinkRace(RACE_FIEND) and c:IsLinkAttribute(ATTRIBUTE_LIGHT)
end

function s.fusfilter(c)
	return c:IsRace(RACE_FIEND)
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end

function s.eqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsType(TYPE_LINK)
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsControler(tp) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or not tc:IsLocation(LOCATION_MZONE) then
			Duel.SendtoGrave(c,REASON_EFFECT)
			return
		end
		if not Duel.Equip(tp,c,tc) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(tc)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end

function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
