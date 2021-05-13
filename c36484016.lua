--ミラクルシンクロフュージョン
function c36484016.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,c36484016.filter,LOCATION_MZONE+LOCATION_GRAVE,Card.IsAbleToRemove,aux.FMaterialRemove,{
		get_fcheck=c36484016.get_fcheck
	})
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36484016,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c36484016.drcon)
	e2:SetTarget(c36484016.drtg)
	e2:SetOperation(c36484016.drop)
	c:RegisterEffect(e2)
end
function c36484016.filter(c)
	return aux.IsMaterialListType(c,TYPE_SYNCHRO)
end
function c36484016.get_fcheck(fc)
	return fc.synchro_fusion_check or c36484016.fcheck
end
function c36484016.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionType,1,nil,TYPE_SYNCHRO)
end
function c36484016.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,0x41)==0x41 and rp==1-tp and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c36484016.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c36484016.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
