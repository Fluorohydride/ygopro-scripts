--禁止令
function c43711255.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43711255.target)
	e1:SetOperation(c43711255.activate)
	c:RegisterEffect(e1)
	--forbidden
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_FORBIDDEN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0x7f,0x7f)
	e2:SetTarget(c43711255.bantg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c43711255.bantg(e,c)
	local code1,code2=c:GetOriginalCodeRule()
	local fcode=e:GetLabelObject():GetLabel()
	return (code1==fcode or code2==fcode) and (not c:IsOnField() or c:GetRealFieldID()>e:GetFieldID())
end
function c43711255.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c43711255.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	Duel.AdjustInstantly(e:GetHandler())
end
