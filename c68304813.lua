--冥界の宝札
function c68304813.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(68304813,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c68304813.condition)
	e2:SetTarget(c68304813.target)
	e2:SetOperation(c68304813.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_MSET)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c68304813.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c68304813.valcheck(e,c)
	if c:GetMaterial():IsExists(Card.IsType,2,nil,TYPE_MONSTER) then
		e:GetLabelObject():SetLabel(1)
		e:GetLabelObject():GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
		e:GetLabelObject():GetLabelObject():SetLabel(0)
	end
end
function c68304813.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsSummonType(SUMMON_TYPE_ADVANCE) and tc:IsSummonPlayer(tp) and e:GetLabel()==1
end
function c68304813.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c68304813.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
